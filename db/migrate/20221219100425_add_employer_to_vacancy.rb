# frozen_string_literal: true

class AddEmployerToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacancies, :employer, null: false, foreign_key: true
  end
end
