class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.boolean :event
      t.boolean :holiday
      t.boolean :local
      t.boolean :monthly
      t.boolean :regional
      t.references :highlightable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
