class AddActiveToDataresources < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :visible, :boolean, default: true
    add_column :event_records, :visible, :boolean, default: true
    add_column :attractions, :visible, :boolean, default: true
  end
end
