# frozen_string_literal: true

require 'rails_helper'

feature 'Employer can sign up', '
  To create new vacancy,
  as an unregistered user,
  I want to be able to register on the site
' do
  scenario 'Unauthenticated user tries to sign up' do
    visit root_path

    click_on 'Login'
    click_on 'Sign up'

    fill_in 'Email', with: 'test@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    expect(current_path).to eq root_path
  end

  scenario 'Unauthenticated hire tries to sign up with invalid data' do
    visit root_path

    click_on 'Login'
    click_on 'Sign up'

    click_on 'Sign up'

    expect(page).to have_content 'prohibited this employer from being saved'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Registered user does not see the registration' do
    employer = create(:employer)
    sign_in_employer(employer)
    visit root_path

    expect(page).to_not have_content 'Registration'
  end
end
