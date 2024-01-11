class AddPolymorphicToGenericItems < ActiveRecord::Migration[6.1]
  def change
    add_column :generic_items, :generic_itemable_type, :string
    add_column :generic_items, :generic_itemable_id, :integer
  end
end
