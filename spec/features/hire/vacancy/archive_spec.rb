# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can archive his vacancy', '
  in order for hide
  an out-of-date vacancy
  employer can archive it
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }

    before { sign_in_employer employer }

    it 'Employer can archive his vacancy', js: true do
      visit hire_vacancies_path

      click_link "vacancy_id_#{vacancy.id}_archive"

      within "#vacancy_id_#{vacancy.id}" do
        expect(page).to have_content 'archived'
      end
    end
  end
end
