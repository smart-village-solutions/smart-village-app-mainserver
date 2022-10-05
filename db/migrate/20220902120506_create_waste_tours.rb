class CreateWasteTours < ActiveRecord::Migration[5.2]
  def change
    create_table :waste_tours do |t|
      t.string :title
      t.string :waste_type

      t.timestamps
    end

    add_column :waste_location_types, :waste_tour_id, :integer
  end
end
