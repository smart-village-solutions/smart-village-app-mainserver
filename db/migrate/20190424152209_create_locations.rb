# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :department
      t.string :district
      t.string :state
      t.string :country
      t.references :locateable, polymorphic: true, index: true
      t.references :region, index: true
      t.timestamps
    end
  end
end
