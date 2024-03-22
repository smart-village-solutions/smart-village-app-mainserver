class CreateExternalServices < ActiveRecord::Migration[6.1]
  def change
    create_table :external_services do |t|
      t.text :name
      t.text :base_uri
      t.text :resource_config
      t.integer :municipality_id

      t.timestamps
    end
  end
end
