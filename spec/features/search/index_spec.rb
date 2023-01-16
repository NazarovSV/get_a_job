# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can search vacancies by key words', '
  In order to fastest
  find a new job
  user can search vacancy by key words
' do
  describe 'valid input' do
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
  end

  describe 'invalid input' do
    it 'blank input' do
      visit vacancies_path
      click_on 'Search'

      expect(page).to have_content 'Request is empty'
    end
  end
end
