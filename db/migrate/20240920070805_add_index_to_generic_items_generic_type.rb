# frozen_string_literal: true

class AddIndexToGenericItemsGenericType < ActiveRecord::Migration[6.1]
  def change
    add_index :generic_items, :generic_type
  end
end
