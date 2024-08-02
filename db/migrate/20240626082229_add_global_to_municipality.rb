class AddGlobalToMunicipality < ActiveRecord::Migration[6.1]
  def change
    add_column :municipalities, :global, :boolean, default: false
  end
end
