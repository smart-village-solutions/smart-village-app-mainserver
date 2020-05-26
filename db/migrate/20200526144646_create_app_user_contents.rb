class CreateAppUserContents < ActiveRecord::Migration[5.2]
  def change
    create_table :app_user_contents do |t|
      t.text :content
      t.string :data_type
      t.string :data_source

      t.timestamps
    end
  end
end
