# frozen_string_literal: true

require 'rails_helper'

feature 'Any user can add new vacancy', '
  to find a new employee
  user can create a new vacancy
' do
  describe 'Unauthenticated user' do
    given(:vacancy) { build(:vacancy) }
    scenario 'can add new vacancy with phone' do
      visit new_vacancy_path

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

    scenario 'can add new vacancy without phone' do
      visit new_vacancy_path

      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email

      click_on 'Create'


      expect(page).to have_content 'Your vacancy successfully created.'

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
    end



    scenario 'can`t add new vacancy without title' do
      visit new_vacancy_path

      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'can`t add new vacancy without description' do
      visit new_vacancy_path

      fill_in 'Title', with: vacancy.title
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Description can't be blank"
    end

    scenario 'can`t add new vacancy without email' do
      visit new_vacancy_path

      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description

      click_on 'Create'

      expect(page).to have_content "Email can't be blank"
    end
  end
end
