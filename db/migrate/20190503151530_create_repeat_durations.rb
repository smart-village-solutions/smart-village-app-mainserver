class CreateRepeatDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :repeat_durations do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :every_year
      t.references :event_record, index: true
      t.timestamps
    end
  end
end
