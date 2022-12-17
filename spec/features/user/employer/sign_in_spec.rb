# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', "
  In order to create vacancies
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:employer) { create(:employer) }

  background { visit new_employer_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: employer.email
    fill_in 'Password', with: employer.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
