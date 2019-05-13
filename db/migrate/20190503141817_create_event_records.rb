class CreateEventRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :event_records do |t|
      t.integer :parent_id
      t.belongs_to :region
      t.string :description
      t.boolean :repeat
      t.string :title
      t.references :category, index: true
      t.timestamps
    end
  end
end
