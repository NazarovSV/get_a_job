# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can view list of vacancies', '
  to find a new job
  user can view the list of vacancies
' do
  describe 'Unauthenticated user' do
    let!(:vacancies) { create_list(:vacancy, 30) }

    # before { vacancies.first(10).each(&:publish!) }

    it 'sees list of published vacancies' do
      vacancies.first(10).each(&:publish!)

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

    it 'works with pagination' do
      vacancies.each(&:publish!)

      visit vacancies_path

      vacancies.each_slice(10) do |chunk|
        chunk.each do |vacancy|
          expect(page).to have_content vacancy.title
          expect(page).to have_content vacancy.location.city.name
          expect(page).to have_content vacancy.description.truncate(250)
        end

        click_on 'Next'
      end
    end
  end
end
