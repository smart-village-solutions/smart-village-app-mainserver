class AddColumnsToNewsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :external_id, :integer
    add_column :news_items, :title, :string
  end
end
