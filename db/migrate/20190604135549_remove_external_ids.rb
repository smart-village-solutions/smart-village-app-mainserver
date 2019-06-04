class RemoveExternalIds < ActiveRecord::Migration[5.2]
  def change
    remove_column :attractions, :external_id
    remove_column :event_records, :external_id
  end
end
