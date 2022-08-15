class AddPayloadToAttractions < ActiveRecord::Migration[5.2]
  def change
    add_column :attractions, :payload, :text
  end
end
