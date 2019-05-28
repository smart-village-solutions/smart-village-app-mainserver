class ConvertDescriptionToText < ActiveRecord::Migration[5.2]
  def change
    change_column :prices, :description, :text
    change_column :data_providers, :description, :text
    change_column :attractions, :description, :text
    change_column :web_urls, :description, :text
    change_column :event_records, :description, :text
    change_column :accessibility_informations, :description, :text
  end
end
