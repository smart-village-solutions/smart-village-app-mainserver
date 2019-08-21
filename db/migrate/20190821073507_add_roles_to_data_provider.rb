class AddRolesToDataProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :data_providers, :roles, :text
  end
end
