# frozen_string_literal: true

class AddExperienceToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacancies, :experience, index: true, foreign_key: true, null: false
  end
end
