class AddUseYearToOpeningHours < ActiveRecord::Migration[5.2]
  def change
    add_column :opening_hours, :use_year, :boolean
  end
end
