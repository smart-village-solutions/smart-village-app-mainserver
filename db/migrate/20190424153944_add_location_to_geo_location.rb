class AddLocationToGeoLocation < ActiveRecord::Migration[5.2]
  def change
    add_reference :geo_locations, :location, index: true
  end
end
