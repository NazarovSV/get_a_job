# frozen_string_literal: true

class RenameCategoryToEmployment < ActiveRecord::Migration[6.1]
  def change
    rename_table :categories, :employments
    rename_column :vacancies, :category_id, :employment_id
  end
end
