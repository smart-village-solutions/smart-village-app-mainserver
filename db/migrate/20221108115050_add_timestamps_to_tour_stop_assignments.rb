class AddTimestampsToTourStopAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :tour_stop_assignments, :created_at, :datetime
    add_column :tour_stop_assignments, :updated_at, :datetime
  end
end
