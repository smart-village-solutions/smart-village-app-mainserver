class AddMunicipalityToWasteLocationTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :waste_location_types, :municipality_id, :integer
    add_column :waste_tours, :municipality_id, :integer
    add_column :waste_pick_up_times, :municipality_id, :integer
  end
end
