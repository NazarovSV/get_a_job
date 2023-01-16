# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign in', "
  In order to registered as candidate
  As an unauthenticated user
  I'd like to be able to sign in
" do
  let(:employee) { create(:employee) }

  before { visit new_employee_session_path }

  it 'Registered user tries to sign in' do
    fill_in 'Email', with: employee.email
    fill_in 'Password', with: employee.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  it 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
