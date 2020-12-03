class FixPrecisionInGeoLocations < ActiveRecord::Migration[5.2]
  def change
    change_column :geo_locations, :latitude, :double
    change_column :geo_locations, :longitude, :double
  end
end
