# frozen_string_literal: true

require 'rails_helper'

feature 'Employer can view list of his vacancies', '
  Employer can view the list of his vacancies
  for control
' do
  describe 'Authenticated employer' do
    let!(:vacancies) { create_list(:vacancy, 10) }
    let!(:employer) { vacancies.first.employer }
    let!(:vacancy) { create(:vacancy, employer:) }

    background do
      sign_in_employer(employer)
      visit hire_vacancies_path
    end

    scenario 'User sees only his vacancies' do
      expect(page).to have_content vacancies.first.title
      expect(page).to have_content "#{vacancies.first.description[0..250]}..."

      expect(page).to have_content vacancy.title
      expect(page).to have_content "#{vacancy.description[0..250]}..."

      vacancies[1..].each do |vacancy|
        expect(page).to_not have_content vacancy.title
        expect(page).to_not have_content "#{vacancy.description[0..250]}..."
      end
    end
  end
end
