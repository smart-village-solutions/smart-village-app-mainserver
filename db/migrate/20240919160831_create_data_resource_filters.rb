class CreateDataResourceFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :data_resource_filters do |t|
      t.string :data_resource_type
      t.integer :municipality_id
      t.text :config

      t.timestamps
    end
  end
end
