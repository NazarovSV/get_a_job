# frozen_string_literal: true

require 'rails_helper'

feature 'Employer can open his vacancies and watch final version', '
  to see the final version of the vacancy
  the employer can open it
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
