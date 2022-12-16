# frozen_string_literal: true

require 'rails_helper'

feature 'Any user can view list of vacancies', '
  to find a new job
  user can create view the list of vacancies
' do
  describe 'Unauthenticated user' do
    let!(:vacancies) { create_list(:vacancy, 10) }

    scenario 'User sees list of all vacancies' do
      visit vacancies_path

      save_and_open_page

      vacancies.each do |vacancy|
        expect(page).to have_content vacancy.title
        expect(page).to have_content "#{vacancy.description[0..250]}..."
      end
    end
  end
end
