class AddAdressToGeoLocation < ActiveRecord::Migration[5.2]
  def change
    add_reference :geo_locations, :adress, index: true
  end
end
