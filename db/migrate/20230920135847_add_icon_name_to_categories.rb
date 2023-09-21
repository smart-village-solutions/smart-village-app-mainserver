class AddIconNameToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :icon_name, :string
  end
end
