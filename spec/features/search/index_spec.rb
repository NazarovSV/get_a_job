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
    let!(:currency) { create_list :currency, 3 }
    let!(:experience) { create_list :experience, 3 }
    let!(:vacancies_for_filter) do
      [
        create(:vacancy,
               :published,
               :without_salary,
               title: 'Ruby developer',
               description: 'Ruby developer',
               category: category.second,
               currency: currency.first,
               experience: experience.first,
               address: 'Ukraine, Kyiv'),
        create(:vacancy,
               :published,
               salary_min: 10_000,
               salary_max: 20_000,
               title: 'Ruby developer 3',
               description: 'Ruby developer 3',
               category: category.first,
               currency: currency.first,
               experience: experience.first,
               address: 'Ukraine, Kyiv'),
        create(:vacancy,
               :published,
               salary_min: 15_000,
               salary_max: nil,
               title: 'Ruby developer 23',
               description: 'Ruby developer 23',
               category: category.first,
               currency: currency.first,
               experience: experience.last,
               address: 'UK, London'),
        create(:vacancy,
               :published,
               salary_min: nil,
               salary_max: 16_000,
               title: 'Ruby developer 4',
               description: 'Ruby developer 4',
               category: category.first,
               currency: currency.second,
               experience: experience.second,
               address: 'Russia, Moscow')
      ]
    end

    it 'return filtered vacancy with keyword', js: true do
      visit vacancies_path

      within '.filters' do
        select currency.first.name, from: 'currency_id'
        select category.first.name, from: 'category_id'
      end

      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title

      within '.filters' do
        select vacancies_for_filter.third.location.city.name, from: 'city_id'
      end

      expect(page).not_to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
    end

    it 'return filtered vacancy without keyword' do
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
