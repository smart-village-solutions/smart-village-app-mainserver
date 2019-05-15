class CreateAttractionsRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :attractions_regions do |t|
      t.references :region, index: true
      t.references :attraction, index: true
    end
  end
end
