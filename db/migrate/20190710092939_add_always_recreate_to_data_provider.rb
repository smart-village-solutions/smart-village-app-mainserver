class AddAlwaysRecreateToDataProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :data_providers, :always_recreate, :text
  end
end
