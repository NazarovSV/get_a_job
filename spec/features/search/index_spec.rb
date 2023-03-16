# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can search vacancies by key words', '
  In order to fastest
  find a new job
  user can search vacancy by key words
' do
  describe 'search' do
    describe 'valid input' do
      let!(:vacancies) do
        [
          create(:vacancy, :published, title: 'title published one'),
          create(:vacancy, :published, title: 'title published second'),
          create(:vacancy, title: 'title drafted'),
          create(:vacancy, :archived, title: 'title archived')
        ]
      end

      it 'return only published vacancy', js: true do
        visit vacancies_path

        fill_in 'request', with: 'title'
        click_on 'Search'

        expect(page).to have_content vacancies.first.title
        expect(page).to have_content vacancies.first.description.truncate(250)

        expect(page).to have_content vacancies.second.title
        expect(page).to have_content vacancies.second.description.truncate(250)

        vacancies[2..].each do |vacancy|
          expect(page).not_to have_content vacancy.title
        end
      end

      it 'return vacancy by key word', js: true do
        visit vacancies_path

        fill_in 'request', with: 'one'
        click_on 'Search'

        expect(page).to have_content vacancies.first.title
        expect(page).to have_content vacancies.first.description.truncate(250)

        vacancies[1..].each do |vacancy|
          expect(page).not_to have_content vacancy.title
        end
      end
    end
  end

  describe 'filter' do
    let!(:category) { create_list :category, 3 }
    let!(:rub) { create(:currency, name: 'RUB', code: :RUB) }
    let!(:usd) { create(:currency, name: 'USD', code: :USD) }
    let!(:eur) { create(:currency, name: 'EUR', code: :EUR) }

    let!(:experience) { create_list :experience, 3 }
    let!(:vacancies_for_filter) do
      [
        create(:vacancy,
               :published,
               :without_salary,
               title: 'Ruby developer',
               description: 'Ruby developer',
               category: category.second,
               currency: rub,
               experience: experience.first,
               address: 'Ukraine, Kyiv'),
        create(:vacancy,
               :published,
               salary_min: 10_000,
               salary_max: 20_000,
               title: 'Java developer',
               description: 'Java developer',
               category: category.first,
               currency: rub,
               experience: experience.first,
               address: 'Ukraine, Kyiv'),
        create(:vacancy,
               :published,
               salary_min: 15_000,
               salary_max: nil,
               title: 'C# developer',
               description: 'C# developer',
               category: category.first,
               currency: rub,
               experience: experience.last,
               address: 'UK, London'),
        create(:vacancy,
               :published,
               salary_min: 4_500,
               salary_max: 5_000,
               title: 'C++ developer',
               description: 'C++ developer',
               category: category.first,
               currency: usd,
               experience: experience.second,
               address: 'Russia, Moscow'),
        create(:vacancy,
               :published,
               salary_min: nil,
               salary_max: 16_000,
               title: 'Go developer',
               description: 'Go developer',
               category: category.first,
               currency: rub,
               experience: experience.second,
               address: 'Russia, Moscow')
      ]
    end

    let!(:currency_converter) { double('CurrencyConverter') }

    before do
      allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
      allow(currency_converter).to receive(:convert).with(amount: 10_000, from: rub, to: rub).and_return(10_000)
      allow(currency_converter).to receive(:convert).with(amount: 15_000, from: rub, to: rub).and_return(15_000)
      allow(currency_converter).to receive(:convert).with(amount: 16_000, from: rub, to: rub).and_return(16_000)
      allow(currency_converter).to receive(:convert).with(amount: 20_000, from: rub, to: rub).and_return(20_000)
      allow(currency_converter).to receive(:convert).with(amount: 4_500, from: usd, to: rub).and_return(4_500 * 2)
      allow(currency_converter).to receive(:convert).with(amount: 5_000, from: usd, to: rub).and_return(5_000 * 2)
    end

    it 'return filtered vacancy without keyword', js: true do
      visit vacancies_path

      within '.filters' do
        select category.first.name, from: 'category_id'
      end

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).to have_content vacancies_for_filter.fourth.title
      expect(page).to have_content vacancies_for_filter.last.title

      within '.filters' do
        select vacancies_for_filter.third.location.city.name, from: 'city_id'
      end

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).not_to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).not_to have_content vacancies_for_filter.fourth.title
      expect(page).not_to have_content vacancies_for_filter.last.title
    end

    it 'return filtered vacancy with keyword', js: true do
      visit vacancies_path

      fill_in 'request', with: 'Java developer'

      within '.filters' do
        select rub.name, from: 'currency_id'
        select category.first.name, from: 'category_id'
      end

      sleep 2

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).not_to have_content vacancies_for_filter.third.title
      expect(page).not_to have_content vacancies_for_filter.fourth.title
      expect(page).not_to have_content vacancies_for_filter.last.title
    end

    it 'return filtered vacancy filtered by min salary', js: true do
      visit vacancies_path
      within '.filters' do
        select rub.name, from: 'currency_id'
      end

      fill_in 'Salary From', with: '17000'

      sleep 5

      expect(page).to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).not_to have_content vacancies_for_filter.fourth.title
      expect(page).not_to have_content vacancies_for_filter.last.title
    end

    it 'return filtered vacancy filtered by max salary', js: true do
      visit vacancies_path

      within '.filters' do
        select rub.name, from: 'currency_id'
      end

      fill_in 'Salary To', with: '14000'

      expect(page).to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).not_to have_content vacancies_for_filter.third.title
      expect(page).to have_content vacancies_for_filter.fourth.title
      expect(page).to have_content vacancies_for_filter.last.title
    end
  end

  describe 'invalid input', js: true do
    it 'return No vacancies found' do
      visit vacancies_path
      fill_in 'request', with: 'qwerfsd'
      click_on 'Search'

      within '.job_list' do
        expect(page).to have_content 'No vacancies found'
      end
    end
  end
end
