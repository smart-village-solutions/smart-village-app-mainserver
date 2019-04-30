class CreatePointOfInterests < ActiveRecord::Migration[5.2]
  def change
    create_table :point_of_interests do |t|
      t.integer :external_id
      t.string :name
      t.string :description
      t.string :mobile_description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
