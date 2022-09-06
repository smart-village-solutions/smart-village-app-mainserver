class AddTourToWastePickUpTime < ActiveRecord::Migration[5.2]
  def change
    add_column :waste_pick_up_times, :waste_tour_id, :integer
  end
end
