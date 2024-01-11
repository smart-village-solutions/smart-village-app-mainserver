class CreateRedemptions < ActiveRecord::Migration[6.1]
  def change
    create_table :redemptions do |t|
      t.integer :member_id
      t.string :redemable_type
      t.bigint :redemable_id
      t.integer :quantity

      t.timestamps
    end
  end
end
