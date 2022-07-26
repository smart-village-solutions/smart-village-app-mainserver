class CreateTourTourStops < ActiveRecord::Migration[5.2]
  def change
    create_table :tour_tour_stops do |t|
      t.integer :tour_id
      t.integer :tour_stop_id
    end
  end
end
