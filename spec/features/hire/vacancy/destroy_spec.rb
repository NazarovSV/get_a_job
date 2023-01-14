# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can destroy his drafted vacancy', '
  In order to delete non-actual vacancy
  As an author of vacancy
  I`d like to be able to destroy my drafted vacancy
' do
  let!(:employer) { create(:employer) }
  let!(:drafted_vacancy) { create(:vacancy, employer:) }
  let!(:published_vacancy) { create(:vacancy, :published, employer:) }
  let!(:archive_vacancy) { create(:vacancy, :archived, employer:) }

  before do
    sign_in_employer(employer)
    visit hire_vacancies_path
  end

  it 'can destroy vacancy', js: true do
    within "#vacancy_id_#{drafted_vacancy.id}" do
      click_on 'Delete'
    end

    expect(page).to have_content 'Your vacancy successfully deleted!'
    expect(page).to_not have_content drafted_vacancy.title
  end

  it 'can`t delete published vacancy' do
    within "#vacancy_id_#{published_vacancy.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end

  it 'can`t delete archived vacancy' do
    within "#vacancy_id_#{archive_vacancy.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end
end
