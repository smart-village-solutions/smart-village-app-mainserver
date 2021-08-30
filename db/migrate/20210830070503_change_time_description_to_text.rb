class ChangeTimeDescriptionToText < ActiveRecord::Migration[5.2]
  def change
    change_column :fixed_dates, :time_description, :text
  end
end
