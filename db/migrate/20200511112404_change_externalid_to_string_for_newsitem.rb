class ChangeExternalidToStringForNewsitem < ActiveRecord::Migration[5.2]
  def change
    change_column :news_items, :external_id, :text
  end
end
