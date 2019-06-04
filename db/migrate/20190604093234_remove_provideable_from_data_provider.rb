class RemoveProvideableFromDataProvider < ActiveRecord::Migration[5.2]
  def change
    remove_column :data_providers, :provideable_type, :string
    remove_column :data_providers, :provideable_id, :string
  end
end
