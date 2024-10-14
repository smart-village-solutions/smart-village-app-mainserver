# frozen_string_literal: true

class AddPositionToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :position, :integer, default: 0
  end
end
