class CreateWebUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :web_urls do |t|
      t.string :url
      t.string :description
      t.references :web_urlable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
