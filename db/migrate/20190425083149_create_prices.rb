class CreatePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|
      t.string :name
      t.float :amount
      t.boolean :group_price
      t.integer :age_from
      t.integer :age_to
      t.integer :min_adult_count
      t.integer :max_adult_count
      t.integer :min_children_count
      t.integer :max_children_count
      t.string :description
      t.string :category
      t.references :priceable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
