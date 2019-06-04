class AddDataproviderToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :data_provider_id, :integer
    add_column :news_items, :data_provider_id, :integer
    add_column :event_records, :data_provider_id, :integer
    add_column :attractions, :data_provider_id, :integer
  end
end
