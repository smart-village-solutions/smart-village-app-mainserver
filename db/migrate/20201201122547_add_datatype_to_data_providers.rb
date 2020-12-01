class AddDatatypeToDataProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :data_providers, :data_type, :integer, default: 0
  end
end
