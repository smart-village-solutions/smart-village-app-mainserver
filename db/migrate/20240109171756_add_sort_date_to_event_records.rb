class AddSortDateToEventRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :event_records, :sort_date, :datetime
  end
end
