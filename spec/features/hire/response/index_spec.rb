# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can view responses on his vacancies', '
  in order to hire to close a vacancy,
  the employer can see the responses to the vacancy
' do
  describe 'Authenticated employer' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }
    let!(:current_responses) { create_list(:response, 5, vacancy:) }

    describe 'as author of vacancy' do
      before { sign_in_employer employer }

      it 'employer can see the responses on vacancy' do
        visit hire_vacancy_path(vacancy)

        click_on 'Responses'

        current_responses.each do |current_response|
          within("#response_id_#{current_response.id}") do
            expect(page).to have_content current_response.email
            expect(page).to have_link('Resume', href: current_response.resume_url)
          end
        end
      end
    end
  end
end
