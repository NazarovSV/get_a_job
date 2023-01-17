# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.references :employee
      t.references :vacancy
      t.string :email, null: false
      t.string :phone
      t.string :resume_url, null: false
      t.string :covering_letter

      t.timestamps
    end
  end
end
