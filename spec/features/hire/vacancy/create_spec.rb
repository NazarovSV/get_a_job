# frozen_string_literal: true

require 'rails_helper'

describe 'Only authenticated user as employer can add new vacancy', '
  to find a new employee
  user can register as hire
  and create a new vacancy
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let(:vacancy) { build(:vacancy, employer:) }

    before do
      sign_in_employer(employer)
      visit hire_vacancies_path
      click_on 'My vacancies'
      click_on 'New'
    end

    it 'can add new vacancy with phone' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Phone', with: vacancy.phone
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content 'Your vacancy successfully created.'

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.phone
      expect(page).to have_content vacancy.email
    end

    it 'can add new vacancy without phone' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content 'Your vacancy successfully created.'

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
    end

    it 'can`t add new vacancy without title' do
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end

    it 'can`t add new vacancy without description' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Description can't be blank"
    end

    it 'can`t add new vacancy without email' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description

      click_on 'Create'

      expect(page).to have_content "Email can't be blank"
    end
  end

  describe 'Unathenticated user' do
    it 'can`t access to creating vacancy path' do
      visit new_hire_vacancy_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end