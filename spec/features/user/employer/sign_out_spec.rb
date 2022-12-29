# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can sign out', '
  to end the session,
  as an authenticated user,
  I would like to log out
' do
  it 'Registered user tries to sign out' do
    employer = create(:employer)
    sign_in_employer(employer)

    visit root_path

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end

  it 'Unregistered user tries to sign out' do
    visit root_path

    expect(page).not_to have_content 'Logout'
  end
end
