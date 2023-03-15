# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can search vacancies by key words', '
  In order to fastest
  find a new job
  user can search vacancy by key words
' do
  describe 'valid input' do
    let!(:category) { create_list :category, 3 }
    let!(:currency) { create_list :currency, 3 }
    let!(:experience) { create_list :experience, 3 }
    let!(:location_kiev) { create :location, address: 'Ukraine, Kyiv' }
    let!(:location_moscow) { create :location, address: 'Russia, Moscow' }
    let!(:location_london) { create :location, address: 'UK, London' }

    let!(:vacancies_for_filter) do
      [
        create(:vacancy,
               :published,
               :without_salary,
               title: 'Ruby developer',
               description: 'Ruby developer',
               location: location_kiev,
               category: category.second,
               currency: currency.first,
               experience: experience.first),
        create(:vacancy,
               :published,
               salary_min: 10_000,
               salary_max: 20_000,
               title: 'Ruby developer 2',
               description: 'Ruby developer 2',
               location: location_kiev,
               category: category.first,
               currency: currency.first,
               experience: experience.first),
        create(:vacancy,
               :published,
               salary_min: 15_000,
               salary_max: nil,
               title: 'Ruby developer 23',
               description: 'Ruby developer 23',
               location: location_london,
               category: category.first,
               currency: currency.first,
               experience: experience.last),
        create(:vacancy,
               :published,
               salary_min: nil,
               salary_max: 16_000,
               title: 'Ruby developer 33',
               description: 'Ruby developer 33',
               location: location_moscow,
               category: category.first,
               currency: currency.second,
               experience: experience.second)
      ]
    end

    let!(:vacancies) do
      [
        create(:vacancy, :published, title: 'title published one'),
        create(:vacancy, :published, title: 'title published second'),
        create(:vacancy, title: 'title drafted'),
        create(:vacancy, :archived, title: 'title archived')
      ]
    end

    it 'return only published vacancy' do
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

    it 'return vacancy by key word' do
      visit vacancies_path

      fill_in 'request', with: 'one'
      click_on 'Search'

      expect(page).to have_content vacancies.first.title
      expect(page).to have_content vacancies.first.description.truncate(250)

      vacancies[1..].each do |vacancy|
        expect(page).not_to have_content vacancy.title
      end
    end

    it 'return filtered vacancy with keyword' do
      visit vacancies_path

      within '.filters' do
        select currency.first.name, from: 'currency_id'
        select category.first.name, from: 'category_id'
      end

      expect(page).to have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title

      within '.filters' do
        select location_london.city.name, from: 'city_id'
      end

      expect(page).to_not have_content vacancies_for_filter.second.title
      expect(page).to have_content vacancies_for_filter.third.title
    end

    it 'return filtered vacancy without keyword' do

    end
  end

  describe 'invalid input' do
    it 'blank input' do
      visit vacancies_path
      click_on 'Search'

      expect(page).to have_content 'Request is empty'
    end
  end
end
