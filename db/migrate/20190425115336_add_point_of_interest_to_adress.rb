class AddPointOfInterestToAdress < ActiveRecord::Migration[5.2]
  def change
    add_reference :adresses, :point_of_interest, index: true
  end
end
