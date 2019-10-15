class CreateDataResourceSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :data_resource_settings do |t|
      t.integer :data_provider_id
      t.string :data_resource_type
      t.string :settings

      t.timestamps
    end
  end
end
