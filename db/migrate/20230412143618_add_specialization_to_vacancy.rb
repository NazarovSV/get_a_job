# frozen_string_literal: true

class AddSpecializationToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacancies, :specialization, foreign_key: true
  end
end
