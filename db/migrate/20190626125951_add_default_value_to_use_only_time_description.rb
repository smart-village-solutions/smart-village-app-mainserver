class AddDefaultValueToUseOnlyTimeDescription < ActiveRecord::Migration[5.2]
  def change
    change_column_default :fixed_dates, :use_only_time_description, false
  end
end
