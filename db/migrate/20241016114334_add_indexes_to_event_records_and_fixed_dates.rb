# frozen_string_literal: true

class AddIndexesToEventRecordsAndFixedDates < ActiveRecord::Migration[6.1]
  def change
    # Indizes für die fixed_dates Tabelle
    add_index :fixed_dates, %i[dateable_type dateable_id date_start date_end],
              name: "index_fixed_dates_on_dateable_type_id_date_start_date_end"

    # Indizes für die event_records Tabelle
    add_index :event_records, :recurring, name: "index_event_records_on_recurring"
    add_index :event_records, :visible, name: "index_event_records_on_visible"

    # Optional: Indizes für häufig abgefragte Kombinationen
    add_index :event_records, %i[visible recurring], name: "index_event_records_on_visible_and_recurring"
    add_index :event_records, %i[visible data_provider_id], name: "index_event_records_on_visible_and_data_provider_id"
  end
end
