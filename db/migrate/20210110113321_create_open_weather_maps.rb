class CreateOpenWeatherMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :open_weather_maps do |t|
      t.text :data

      t.timestamps
    end
  end
end
