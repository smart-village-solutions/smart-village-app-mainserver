class AddPreferencesToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :preferences, :text
  end
end
