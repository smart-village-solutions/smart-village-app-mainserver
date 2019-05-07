class AddTypeToAttraction < ActiveRecord::Migration[5.2]
  def change
    add_column :attractions, :type, :string, null: false, default: "PointOfInterest"
  end
end
