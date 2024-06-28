class AddBlobalsettingsToDataResourceSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :data_resource_settings, :global_settings, :text, limit: 12.megabytes
  end
end
