# frozen_string_literal: true

class CreateExternalServiceCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :external_service_categories do |t|
      t.string :external_id
      t.references :external_service, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
