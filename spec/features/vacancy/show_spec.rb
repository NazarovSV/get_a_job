# frozen_string_literal: true

require 'rails_helper'

describe 'Any user can open vacancy and watch full info about job', '
  to find a new job
  user can open vacancy page
  and watch all info about job
' do
  describe 'Unauthenticated user' do
    let!(:vacancies) { create_list(:vacancy, 3) }

    it 'User can`t open draft vacancy' do
      visit vacancies_path

      expect(page).to have_no_link("vacancy_id_#{vacancies.first.id}")
    end

    it 'User can open publish vacancy' do
      vacancy = vacancies.second
      vacancy.publish!

      visit vacancies_path

      click_link("vacancy_id_#{vacancy.id}")

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
      expect(page).to have_content vacancy.phone
    end

    describe 'archived vacancy' do
      it 'User can`t open archive vacancy by link' do
        vacancy = vacancies.last
        vacancy.publish!
        vacancy.archive!

        visit vacancies_path

        expect(page).to have_no_link("vacancy_id_#{vacancy.id}")
      end

      it 'User can open vacancy by url' do
        vacancy = vacancies.last
        vacancy.publish!
        vacancy.archive!

        visit vacancy_path vacancy

        expect(page).to have_selector('.archived_flash')
      end
    end
  end
end
