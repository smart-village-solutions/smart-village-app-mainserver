class CreateOpeningHours < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_hours do |t|
      t.string :weekday
      t.datetime :date_from
      t.datetime :date_to
      t.string :time_from
      t.string :time_to
      t.integer :sort_number
      t.boolean :open
      t.string :description

      t.timestamps
    end
  end
end
