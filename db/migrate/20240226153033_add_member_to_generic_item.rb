class AddMemberToGenericItem < ActiveRecord::Migration[6.1]
  def change
    add_column :generic_items, :member_id, :integer
  end
end
