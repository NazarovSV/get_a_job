class CreateHouseNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :house_numbers do |t|
      t.string :number
      t.belongs_to :street, null: false, foreign_key: true

      t.timestamps
    end
  end
end
