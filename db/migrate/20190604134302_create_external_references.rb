class CreateExternalReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :external_references do |t|
      t.timestamps

      t.string :unique_id
      t.integer :data_provider_id
      t.integer :external_id
      t.string :external_type
    end
  end
end
