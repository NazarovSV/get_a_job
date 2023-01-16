# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can search vacancies by key words', '
  In order to fastest
  find a new job
  user can search vacancy by key words
' do
  describe 'valid input' do
    let!(:vacancies) { create_list(:vacancy, 10, :published) }

    it 'return vacancy' do
      visit vacancies_path

      fill_in 'request', with: vacancies.first.title
      click_on 'Search'

      expect(page).to have_content vacancies.first.title
      expect(page).to have_content vacancies.first.description.truncate(250)

      vacancies[1..].each do |vacancy|
        expect(page).not_to have_content vacancy.title
      end
    end
  end

  describe 'invalid input' do
    scenario 'blank input' do
      visit vacancies_path
      click_on 'Search'

      expect(page).to have_content 'Request is empty'
    end

  end
end
