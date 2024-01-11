class DiscountType < ActiveRecord::Migration[6.1]
  def change
    create_table :discount_types do |t|
      t.decimal :original_price, precision: 10, scale: 2
      t.decimal :discounted_price, precision: 10, scale: 2
      t.decimal :discount_percentage, precision: 5, scale: 0
      t.decimal :discount_amount, precision: 10, scale: 2

      # Polymorphische Assoziation
      t.string :discountable_type
      t.bigint :discountable_id

      t.timestamps
    end

    add_index :discount_types, [:discountable_type, :discountable_id]
  end
end
