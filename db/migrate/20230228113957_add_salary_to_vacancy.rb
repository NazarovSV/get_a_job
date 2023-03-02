# frozen_string_literal: true

class AddSalaryToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_column :vacancies, :salary_min, :integer
    add_column :vacancies, :salary_max, :integer
  end
end
