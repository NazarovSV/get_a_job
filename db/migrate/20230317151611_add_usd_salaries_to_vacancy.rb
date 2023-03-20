class AddUsdSalariesToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_column :vacancies, :usd_salary_min, :integer, null: true
    add_column :vacancies, :usd_salary_max, :integer, null: true
  end
end
