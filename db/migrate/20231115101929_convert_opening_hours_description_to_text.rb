class ConvertOpeningHoursDescriptionToText < ActiveRecord::Migration[5.2]
  def change
    change_column :opening_hours, :description, :text
  end
end
