# frozen_string_literal: true

class AddCategoryToVacancies < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacancies, :category, null: false, foreign_key: true
  end
end
