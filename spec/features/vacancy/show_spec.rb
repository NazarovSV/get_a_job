# frozen_string_literal: true

require 'rails_helper'

feature 'Any user can open vacancy and watch full info about job', '
  to find a new job
  user can open vacancy page
  and watch all info about job
' do
  describe 'Unauthenticated user' do
    let!(:vacancies) { create_list(:vacancy, 2) }
    let!(:vacancy) { vacancies.first }
    scenario 'User can open vacancy' do
      visit vacancies_path

      click_link("vacancy_id_#{vacancy.id}")

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
      expect(page).to have_content vacancy.phone
    end
  end
end
