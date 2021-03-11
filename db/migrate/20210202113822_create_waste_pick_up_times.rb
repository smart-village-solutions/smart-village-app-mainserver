class CreateWastePickUpTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :waste_pick_up_times do |t|
      t.integer :waste_location_type_id
      t.date :pickup_date

      t.timestamps
    end
  end
end
