# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can open response', '
  In order to hire to close a vacancy,
  the employer can open response of the vacancy
' do
  describe 'Authenticated employer' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }
    let!(:current_responses) { create_list(:response, 5, vacancy:) }

    describe 'as author of vacancy' do
      before { sign_in_employer employer }

      it 'employer can see the responses on vacancy' do
        current_response = current_responses.first

        visit hire_response_path(current_response)

        expect(page).to have_content current_response.email
        expect(page).to have_content current_response.phone
        expect(page).to have_content current_response.covering_letter
        expect(page).to have_link('Resume', href: current_response.resume_url)
      end
    end
  end
end
