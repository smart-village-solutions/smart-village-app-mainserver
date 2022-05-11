class LargerUniqueIdInExternalReferences < ActiveRecord::Migration[5.2]
  def change
    change_column :external_references, :unique_id, :text
  end
end
