# frozen_string_literal: true

module FeatureHelpers
  def sign_in_employer(employer)
    visit new_employer_session_path
    fill_in 'Email', with: employer.email
    fill_in 'Password', with: employer.password

    click_on 'Log in'
  end
end
