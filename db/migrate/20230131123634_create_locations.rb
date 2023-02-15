# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.belongs_to :country, null: false, foreign_key: true
      t.belongs_to :city, null: false, foreign_key: true
      t.belongs_to :vacancy, null: false, foreign_key: true
      t.string :address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
