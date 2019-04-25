class CreateOpeningTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_times do |t|
      t.string :name
      t.datetime :date_from
      t.datetime :date_to
      t.string :time_from
      t.string :time_to
      t.integer :sort_number
      t.boolean :open

      t.timestamps
    end
  end
end
