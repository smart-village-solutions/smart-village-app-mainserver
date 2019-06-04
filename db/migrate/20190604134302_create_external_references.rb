class CreateExternalReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :external_references do |t|
      t.string :external_id
      t.integer :data_provider_id
      t.integer :external_id
      t.string :external_type

      t.timestamps
    end
  end
end
