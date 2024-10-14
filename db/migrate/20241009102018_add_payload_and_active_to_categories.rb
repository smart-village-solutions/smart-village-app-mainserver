# frozen_string_literal: true

class AddPayloadAndActiveToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :payload, :text
    add_column :categories, :active, :boolean, default: true
  end
end
