class ChangeMobileDescriptionToText < ActiveRecord::Migration[5.2]
  def change
    change_column :attractions, :mobile_description, :text
  end
end
