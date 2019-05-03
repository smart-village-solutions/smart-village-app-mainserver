class CreateEventRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :event_records do |t|
      t.string :region
      t.string :description
      t.boolean :repeat
      t.string :title

      t.timestamps
    end
  end
end
