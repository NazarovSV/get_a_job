# frozen_string_literal: true

class AddTranslateToSpecialization < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Specialization.create_translation_table! name: { type: :string, null: false }
      end

      dir.down do
        Specialization.drop_translation_table!
      end
    end
  end
end
