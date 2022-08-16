class CreateTourStopAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :tour_stop_assignments do |t|
      t.integer :tour_id
      t.integer :tour_stop_id
    end
  end
end
