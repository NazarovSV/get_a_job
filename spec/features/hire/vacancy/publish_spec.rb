# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can publish his new vacancy', '
  in order for everyone
  to see the vacancy
  employer can publish it
' do
  describe 'Authenticated user' do
    describe 'New vacancy' do
      let!(:employer) { create(:employer) }
      let!(:vacancy) { create(:vacancy, employer:) }

      before { sign_in_employer employer }

      describe 'Employer can publish his vacancy', js: true do
        it 'from list of all his vacancies' do
          visit hire_vacancies_path

          click_link "vacancy_id_#{vacancy.id}_publish"

          within "#vacancy_id_#{vacancy.id}" do
            expect(page).to have_content 'Published'
          end
        end

        it 'from his vacancy' do
          visit hire_vacancy_path(vacancy)

          click_link "vacancy_id_#{vacancy.id}_publish"

          within "#vacancy_id_#{vacancy.id}_show" do
            expect(page).to have_content 'Published'
          end
        end
      end
    end

    describe 'Archive vacancy' do
      let!(:employer) { create(:employer) }
      let!(:vacancy) { create(:vacancy, :archived, employer:) }

      before { sign_in_employer employer }

      describe 'Employer can publish his archive vacancy', js: true do
        it 'from list of all his vacancies' do
          visit hire_vacancies_path

          click_link "vacancy_id_#{vacancy.id}_publish"

          within "#vacancy_id_#{vacancy.id}" do
            expect(page).to have_content 'Published'
          end
        end

        it 'from his vacancy' do
          visit hire_vacancy_path(vacancy)

          click_link "vacancy_id_#{vacancy.id}_publish"

          within "#vacancy_id_#{vacancy.id}_show" do
            expect(page).to have_content 'Published'
          end
        end
      end
    end
  end
end
