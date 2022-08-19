class AddMunicipalityToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :municipality_id, :integer
    add_column :static_contents, :municipality_id, :integer
    add_column :open_weather_maps, :municipality_id, :integer
    add_column :notification_devices, :municipality_id, :integer
    add_column :categories, :municipality_id, :integer
    add_column :app_user_contents, :municipality_id, :integer
    add_column :data_providers, :municipality_id, :integer
  end
end
