# frozen_string_literal: true

class AddStateToVacancies < ActiveRecord::Migration[6.1]
  def change
    add_column :vacancies, :state, :string, index: true
  end
end
