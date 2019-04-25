class AddDataProviderToContact < ActiveRecord::Migration[5.2]
  def change
    add_reference :contacts, :data_provider, index: true
  end
end
