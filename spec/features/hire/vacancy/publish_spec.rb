# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can publish his new vacancy', '
  in order for everyone
  to see the vacancy
  you can publish it
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    before { sign_in_employer employer }

    it 'Employer can publish his vacancy', js: true do
      visit hire_vacancies_path

      click_link "vacancy_id_#{vacancy.id}_publish"

      within "#vacancy_id_#{vacancy.id}" do
        expect(page).to have_content 'published'
      end
    end
  end
end
