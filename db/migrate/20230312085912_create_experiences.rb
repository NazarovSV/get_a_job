# frozen_string_literal: true

class CreateExperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :experiences do |t|
      t.string :description

      t.timestamps
    end
  end
end
