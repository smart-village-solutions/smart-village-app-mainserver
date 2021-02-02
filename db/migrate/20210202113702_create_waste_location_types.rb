class CreateWasteLocationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :waste_location_types do |t|
      t.string :waste_type
      t.integer :address_id

      t.timestamps
    end
  end
end
