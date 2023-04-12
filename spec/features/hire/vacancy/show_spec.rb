# frozen_string_literal: true

require 'rails_helper'

describe 'Employer can open his vacancies and watch final version', '
  to see the final version of the vacancy
  the employer can open it
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) { create_list(:vacancy, 2, employer:) }
    let!(:vacancy) { vacancies.first }

    before { sign_in_employer employer }

    it 'User can open his vacancy' do
      visit hire_vacancies_path

      click_link("vacancy_id_#{vacancy.id}_link")

      expect(page).to have_content(vacancy.title)
                  .and have_content(vacancy.description)
                  .and have_content(vacancy.email)
                  .and have_content(vacancy.phone)
                  .and have_content(vacancy.location.address)
                  .and have_content(vacancy.employment.name)
    end

    describe 'User can see salary range' do
      it 'User can see salary range' do
        vacancy = vacancies.second
        vacancy.publish!

        visit hire_vacancy_path(vacancy)

        expect(page).to have_content "#{vacancy.salary_min} - #{vacancy.salary_max} #{vacancy.currency.name}"
      end

      it 'User can see min salary if only min salary is set' do
        vacancy = create(:vacancy, :published, salary_min: 2000, salary_max: nil, employer:)

        visit hire_vacancy_path(vacancy)

        expect(page).to have_content "From 2000 #{vacancy.currency.name}"
      end

      it 'User can see max salary if only max salary is set' do
        vacancy = create(:vacancy, :published, salary_min: nil, salary_max: 2000, employer:)

        visit hire_vacancy_path(vacancy)

        expect(page).to have_content "To 2000 #{vacancy.currency.name}"
      end

      it 'User don`t see any currency if no salary' do
        vacancy = create(:vacancy, :published, :without_salary, employer:)

        visit hire_vacancy_path(vacancy)

        expect(page).not_to have_content 'Salary'
      end
    end

    it 'have published state if it published' do
      visit hire_vacancy_path(create(:vacancy, :published, employer:))

      within('.current_state') do
        expect(page).to have_content 'Published'
      end
    end

    it 'have drafted state if it drafted' do
      visit hire_vacancy_path(create(:vacancy, employer:))

      within('.current_state') do
        expect(page).to have_content 'Drafted'
      end
    end

    it 'have archived state if it archived' do
      visit hire_vacancy_path(create(:vacancy, :archived, employer:))

      within('.current_state') do
        expect(page).to have_content 'Archived'
      end
    end
  end
end
