# frozen_string_literal: true

class CreateNewsItems < ActiveRecord::Migration[5.2]
  def change
    create_table :news_items do |t|
      t.string :author
      t.boolean :full_version
      t.integer :characters_to_be_shown
      t.datetime :publication_date
      t.datetime :published_at
      t.boolean :show_publish_date
      t.string :news_type
      t.timestamps
    end
  end
end
