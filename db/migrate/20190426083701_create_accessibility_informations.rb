class CreateAccessibilityInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :accessibility_informations do |t|
      t.string :description
      t.string :types
      t.references :accessable, polymorphic: true, index: { name: :index_access_info_on_accessable_type_and_id }
      t.timestamps
    end
  end
end
