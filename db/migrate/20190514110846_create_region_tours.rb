class CreateRegionTours < ActiveRecord::Migration[5.2]
  def change
    create_table :region_tours do |t|
      t.references :region, index: true
      t.references :tour, index: true
    end
  end
end
