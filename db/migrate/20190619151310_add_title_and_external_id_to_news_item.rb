class AddTitleAndExternalIdToNewsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :external_id, :bigint
    add_column :news_items, :title, :string
  end
end
