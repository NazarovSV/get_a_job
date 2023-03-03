# frozen_string_literal: true

class CreateExchangeRates < ActiveRecord::Migration[6.1]
  def change
    create_table :exchange_rates do |t|
      t.references :from_currency,  null: false, foreign_key: { to_table: :currencies }
      t.references :to_currency, null: false, foreign_key: { to_table: :currencies }
      t.float :rate

      t.timestamps
    end
  end
end
