class CreateGenericItems < ActiveRecord::Migration[5.2]
  def change
    create_table :generic_items do |t|
      t.string :generic_type
      t.text :author
      t.datetime :publication_date
      t.datetime :published_at
      t.text :external_id
      t.boolean :visible, default: true
      t.text :title
      t.text :teaser
      t.text :description
      t.integer :data_provider_id
      t.text :payload
      t.string :ancestry

      t.timestamps
    end
  end
end
