class ChangeExternalIdTypeForAttractions < ActiveRecord::Migration[5.2]
  def change
    change_column :attractions, :external_id, :string
  end
end
