# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can view list of vacancies', '
  to find a new job
  user can view the list of vacancies
' do
  describe 'Unauthenticated user' do
    let!(:vacancies) { create_list(:vacancy, 10) }

    before { vacancies.first(5).each(&:publish!) }

    it 'User sees list of published vacancies' do
      visit vacancies_path

      vacancies.each do |vacancy|
        if vacancy.published?
          expect(page).to have_content vacancy.title
          expect(page).to have_content vacancy.location.city.name
          expect(page).to have_content vacancy.description.truncate(250)
        else
          expect(page).not_to have_content vacancy.title
          expect(page).not_to have_content vacancy.description.truncate(250)
        end
      end
    end
  end
end
