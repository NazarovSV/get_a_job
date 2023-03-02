# frozen_string_literal: true

class AddCurrencyToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_reference :vacancies, :currency, foreign_key: true
  end
end
