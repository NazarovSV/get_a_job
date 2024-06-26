# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can search vacancies by key words', '
  In order to fastest
  find a new job
  user can search vacancy by key words
' do
  include_context 'Currency'

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
    let!(:employments) { create_list :employment, 3 }
    let!(:experience) { create_list :experience, 3 }
    let!(:specializations) { create_list :specialization, 2 }
    let!(:vacancies_for_filter) do
      [
        create(:vacancy,
               :published,
               :without_salary,
               title: 'Ruby developer',
               description: 'Ruby developer',
               employment: employments.second,
               currency: @rub,
               experience: experience.first,
               address: 'Ukraine, Kyiv',
               specialization: specializations.first,
               skip_fill_usd_salaries: false),
        create(:vacancy,
               :published,
               salary_min: 10_000,
               salary_max: 21_000,
               title: 'Java developer',
               description: 'Java developer',
               employment: employments.first,
               currency: @rub,
               experience: experience.first,
               address: 'Ukraine, Kyiv',
               specialization: specializations.first,
               skip_fill_usd_salaries: false),
        create(:vacancy,
               :published,
               salary_min: 15_000,
               salary_max: nil,
               title: 'C# developer',
               description: 'C# developer',
               employment: employments.first,
               currency: @rub,
               experience: experience.last,
               address: 'UK, London',
               specialization: specializations.second,
               skip_fill_usd_salaries: false),
        create(:vacancy,
               :published,
               salary_min: 4_500,
               salary_max: 5_000,
               title: 'C++ developer',
               description: 'C++ developer',
               employment: employments.first,
               currency: @usd,
               experience: experience.second,
               address: 'Russia, Moscow',
               specialization: specializations.second,
               skip_fill_usd_salaries: false),
        create(:vacancy,
               :published,
               salary_min: nil,
               salary_max: 16_000,
               title: 'Go developer',
               description: 'Go developer',
               employment: employments.first,
               currency: @rub,
               experience: experience.second,
               address: 'Russia, Moscow',
               specialization: specializations.second,
               skip_fill_usd_salaries: false)
      ]
    end

    let!(:currency_converter) { instance_double('CurrencyConverter') }

    before do
      allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
      allow(currency_converter).to receive(:convert).with(amount: 10_000, from: @rub, to: @rub).and_return(10_000)
      allow(currency_converter).to receive(:convert).with(amount: 15_000, from: @rub, to: @rub).and_return(15_000)
      allow(currency_converter).to receive(:convert).with(amount: 16_000, from: @rub, to: @rub).and_return(16_000)
      allow(currency_converter).to receive(:convert).with(amount: 20_000, from: @rub, to: @rub).and_return(20_000)
      allow(currency_converter).to receive(:convert).with(amount: 4_500, from: @usd, to: @rub).and_return(4_500 * 2)
      allow(currency_converter).to receive(:convert).with(amount: 5_000, from: @usd, to: @rub).and_return(5_000 * 2)
      allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @usd.id).and_return(1.0)
      allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @rub.id).and_return(1.0 / 80)
    end

    it 'return filtered vacancy without keyword', js: true do
      visit vacancies_path

      within '.filters' do
        select employments.first.name, from: 'employment_id'
      end

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).to have_content vacancies_for_filter.fourth.title
      expect(page).to have_content vacancies_for_filter.last.title

      within '.filters' do
        select specializations.second.name, from: 'specialization_id'
      end

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).not_to have_content vacancies_for_filter.second.title
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
        select @rub.name, from: 'currency_id'
        select employments.first.name, from: 'employment_id'
      end

      wait_for_ajax

      expect(page).not_to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).not_to have_content vacancies_for_filter.third.title
      expect(page).not_to have_content vacancies_for_filter.fourth.title
      expect(page).not_to have_content vacancies_for_filter.last.title
    end

    it 'return filtered vacancy filtered by min salary', js: true do
      visit vacancies_path

      within '.filters' do
        select @rub.name, from: 'currency_id'
        fill_in 'Salary From', with: '17000'
        find('#salary_min').native.send_keys(:enter)
      end

      wait_for_ajax

      expect(page).to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).to have_content vacancies_for_filter.fourth.title
      expect(page).not_to have_content vacancies_for_filter.last.title
    end

    it 'return filtered vacancy filtered by max salary', js: true do
      visit vacancies_path

      within '.filters' do
        select @rub.name, from: 'currency_id'
        fill_in 'Salary To', with: '14000'
        find('#salary_max').native.send_keys(:enter)
      end

      wait_for_ajax

      expect(page).to have_content vacancies_for_filter.first.title
      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
      expect(page).not_to have_content vacancies_for_filter.fourth.title
      expect(page).to have_content vacancies_for_filter.last.title
    end
  end

  describe 'pagination', js: true do
    let!(:employments) { create_list :employment, 3 }
    let!(:vacancies_ruby_first_employment) { [] }

    before do
      15.times do
        vacancies_ruby_first_employment << create(:vacancy,
                                                  :published,
                                                  title: "Ruby Vacancy #{Faker::Name.unique.name}",
                                                  employment: employments.first)
        create(:vacancy, :published, title: "Ruby Another Vacancy #{Faker::Name.unique.name}",
                                     employment: employments.second)
        create(:vacancy, :published, title: "Go Vacancy #{Faker::Name.unique.name}", employment: employments.first)
      end
    end

    it 'works with filter and keywords' do
      visit vacancies_path
      fill_in 'request', with: 'Ruby'

      within '.filters' do
        select employments.first.name, from: 'employment_id'
      end

      size = 10

      vacancies_ruby_first_employment.each_slice(size).with_index do |vacancies, index|
        vacancies.each do |vacancy|
          expect(page).to have_content vacancy.title
        end

        click_on 'Next' unless vacancies_ruby_first_employment.length / size == index
      end
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
