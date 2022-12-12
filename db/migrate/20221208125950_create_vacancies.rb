# frozen_string_literal: true

class CreateVacancies < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancies do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :email, null: false
      t.string :phone, null: true

      t.timestamps
    end
  end
end
