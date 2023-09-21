class AddIndexToEventRecordsExternalId < ActiveRecord::Migration[5.2]
  def change
    add_index :event_records, :external_id
  end
end
