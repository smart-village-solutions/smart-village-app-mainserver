class AddPayloadToNewsItems < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :payload, :text
  end
end
