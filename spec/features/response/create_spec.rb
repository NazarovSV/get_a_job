# frozen_string_literal: true

require 'rails_helper'

describe 'Only authenticated user as employee can response on vacancy', '
  in order to find a new job
  user can register as candidate
  and response on vacancy
' do
  let!(:vacancy) { create(:vacancy, :published) }

  describe 'Employee user' do
    let!(:employee) { create(:employee) }
    let!(:response) { build(:response, employee:) }

    before do
      sign_in_employee(employee)
      visit new_vacancy_response_path(vacancy)
    end

    describe 'valid info' do
      it 'respond to the vacancy with all field filled' do
        fill_in 'Email', with: response.email
        fill_in 'Phone', with: response.phone
        fill_in 'Resume Url', with: response.resume_url
        fill_in 'Covering Letter', with: response.covering_letter

        click_on 'Create'

        expect(page).to have_content 'You applied for a job!'

        expect(page).to have_content response.phone
        expect(page).to have_content response.email
        expect(page).to have_link('Resume', href: response.resume_url)
        expect(page).to have_content response.covering_letter
      end

      it 'respond to the vacancy without optional field' do
        fill_in 'Email', with: response.email
        fill_in 'Resume Url', with: response.resume_url

        click_on 'Create'

        expect(page).to have_content 'You applied for a job!'

        expect(page).to have_content response.email
        expect(page).to have_link('Resume', href: response.resume_url)
      end
    end
  end

  describe 'Unathenticated user' do
    it 'can`t access to creating response' do
      visit new_vacancy_response_path(vacancy)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
