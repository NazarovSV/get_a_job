# frozen_string_literal: true

require 'rails_helper'

describe 'Employee can sign out', '
  to end the session,
  as an authenticated user,
  I would like to log out
' do
  it 'Registered user tries to sign out' do
    employee = create(:employee)
    sign_in_employee(employee)

    visit root_path

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end

  it 'Unregistered user tries to sign out' do
    visit root_path

    expect(page).not_to have_content 'Logout'
  end
end
