class CreateOpeningHours < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_hours do |t|
      t.string :weekday
      t.date :date_from
      t.date :date_to
      t.time :time_from
      t.time :time_to
      t.integer :sort_number
      t.boolean :open
      t.string :description
      t.references :openingable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
