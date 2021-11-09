class AddNoticeToDataProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :data_providers, :notice, :text
  end
end
