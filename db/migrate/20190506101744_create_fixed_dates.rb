class CreateFixedDates < ActiveRecord::Migration[5.2]
  def change
    create_table :fixed_dates do |t|
      t.date :date_start
      t.date :date_end
      t.string :weekday
      t.time :time_start
      t.time :time_end
      t.string :time_description
      t.boolean :use_only_time_description
      t.references :dateable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
