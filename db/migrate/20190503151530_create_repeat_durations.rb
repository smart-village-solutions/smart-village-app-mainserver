class CreateRepeatDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :repeat_durations do |t|
      t.date :start
      t.date :end
      t.boolean :every_year
      t.datetime :updated_at_tmb
      t.references :event_record, index: true
      t.timestamps
    end
  end
end
