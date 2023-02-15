# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can open his vacancies and watch final version', '
  to see the final version of the vacancy
  the employer can open it
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) { create_list(:vacancy, 2, employer:) }
    let!(:vacancy) { vacancies.first }

    before { sign_in_employer employer }

    it 'User can open his vacancy' do
      visit hire_vacancies_path

      click_link("vacancy_id_#{vacancy.id}_link")

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
      expect(page).to have_content vacancy.phone
      expect(page).to have_content vacancy.location.address
    end

    it 'have published state if it published' do
      visit hire_vacancy_path(create(:vacancy, :published, employer:))

      within('.current_state') do
        expect(page).to have_content 'Published'
      end
    end

    it 'have drafted state if it drafted' do
      visit hire_vacancy_path(create(:vacancy, employer:))

      within('.current_state') do
        expect(page).to have_content 'Drafted'
      end
    end

    it 'have archived state if it archived' do
      visit hire_vacancy_path(create(:vacancy, :archived, employer:))

      within('.current_state') do
        expect(page).to have_content 'Archived'
      end
    end
  end
end
