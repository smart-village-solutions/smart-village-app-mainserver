class CreateStaticContents < ActiveRecord::Migration[5.2]
  def change
    create_table :static_contents do |t|
      t.string :name
      t.string :data_type
      t.text :content

      t.timestamps
    end
  end
end
