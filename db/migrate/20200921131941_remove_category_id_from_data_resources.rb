class RemoveCategoryIdFromDataResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :attractions, :category_id
    remove_column :event_records, :category_id
  end
end
