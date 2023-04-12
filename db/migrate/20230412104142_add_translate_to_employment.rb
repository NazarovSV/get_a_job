# frozen_string_literal: true

class AddTranslateToEmployment < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Employment.create_translation_table! name: { type: :string, null: false }
      end

      dir.down do
        Employment.drop_translation_table!
      end
    end
  end
end
