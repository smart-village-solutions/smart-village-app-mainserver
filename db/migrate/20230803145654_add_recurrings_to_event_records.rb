# frozen_string_literal: true

class AddRecurringsToEventRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :event_records, :recurring, :boolean, default: false
    add_column :event_records, :recurring_weekdays, :string
    add_column :event_records, :recurring_type, :integer
    add_column :event_records, :recurring_interval, :integer
  end
end
