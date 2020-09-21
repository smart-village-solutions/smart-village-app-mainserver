class CreateDataResourceCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :data_resource_categories do |t|
      t.integer :data_resource_id
      t.string :data_resource_type
      t.integer :category_id

      t.timestamps
    end
  end
end
