class CreateAttractions < ActiveRecord::Migration[5.2]
  def change
    create_table :attractions do |t|
      t.integer :external_id
      t.string :name
      t.string :description
      t.string :mobile_description
      t.boolean :active, default: true
      t.integer :length_km
      t.integer :means_of_transportation
      t.references :category, index: true

      t.timestamps
    end
  end
end
