class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.belongs_to :country, null: false, foreign_key: true
      # t.belongs_to :city, null: false, foreign_key: true
      # t.belongs_to :street, null: false, foreign_key: true
      # t.belongs_to :house_number, null: false, foreign_key: true
      t.belongs_to :vacancy, null: false, foreign_key: true
      t.string :full_address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
