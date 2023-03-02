# frozen_string_literal: true

class AddTranslateToCategory < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Category.create_translation_table! name: { type: :string, null: false }
      end

      dir.down do
        Category.drop_translation_table!
      end
    end
  end
end
