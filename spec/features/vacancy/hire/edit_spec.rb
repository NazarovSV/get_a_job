# frozen_string_literal: true

require 'rails_helper'

feature 'Employer can edit his vacancy', '
  In order to correct mistakes
  As an author of vacancy
  I`d like to be able to edit my vacancy
' do
  describe 'Authenticated user' do
    given!(:employer) { create(:employer) }
    given!(:vacancy) { create(:vacancy, employer:) }

    background do
      sign_in_employer(employer)
      visit hire_vacancy_path(vacancy)
      click_on 'Edit'
    end

    scenario 'can edit vacancy' do
      email = Faker::Internet.email
      fill_in 'Title', with: 'new title'
      fill_in 'Description', with: 'new description'
      fill_in 'Email', with: email

      click_on 'Save'

      expect(page).to have_content 'Your vacancy successfully updated.'

      expect(page).to have_content 'new title'
      expect(page).to have_content 'new description'
      expect(page).to have_content email
    end
  end

  describe 'Unathenticated user' do
    let!(:vacancy) { create(:vacancy) }

    scenario 'can`t access to editing vacancy path' do
      visit hire_vacancy_url(vacancy)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
