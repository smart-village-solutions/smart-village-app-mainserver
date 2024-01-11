class CreateQuotas < ActiveRecord::Migration[6.1]
  def change
    create_table :quotas do |t|
      t.integer :max_quantity
      t.integer :frequency
      t.integer :max_per_person

      t.string :quotaable_type
      t.bigint :quotaable_id

      t.timestamps
    end

    add_index :quotas, [:quotaable_type, :quotaable_id]
  end
end
