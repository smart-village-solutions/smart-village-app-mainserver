class CreateLunchOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :lunch_offers do |t|
      t.string :name
      t.string :price
      t.integer :lunch_id

      t.timestamps
    end
  end
end
