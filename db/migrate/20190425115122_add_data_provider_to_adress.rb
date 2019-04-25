class AddDataProviderToAdress < ActiveRecord::Migration[5.2]
  def change
    add_reference :adresses, :data_provider, index: true
  end
end
