class ConvertUrlToText < ActiveRecord::Migration[5.2]
  def change
    change_column :web_urls, :url, :text
  end
end
