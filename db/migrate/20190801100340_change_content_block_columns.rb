class ChangeContentBlockColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :content_blocks, :title, :text
    change_column :content_blocks, :intro, :text
  end
end
