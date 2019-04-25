class AddPointOfInterestToContact < ActiveRecord::Migration[5.2]
  def change
    add_reference :contacts, :point_of_interest, index: true
  end
end
