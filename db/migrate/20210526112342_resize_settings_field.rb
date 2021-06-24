class ResizeSettingsField < ActiveRecord::Migration[5.2]
  def change
    change_column :data_resource_settings, :settings, :text, limit: 12.megabytes
  end
end
