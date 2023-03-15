# frozen_string_literal: true

class AddTranslateToExperience < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Experience.create_translation_table! description: { type: :string, null: false }
      end

      dir.down do
        Experience.drop_translation_table!
      end
    end
  end
end
