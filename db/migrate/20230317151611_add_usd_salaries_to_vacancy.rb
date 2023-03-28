# frozen_string_literal: true

class AddUsdSalariesToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_column :vacancies, :usd_salary_min, :float, null: true
    add_column :vacancies, :usd_salary_max, :float, null: true
  end
end
