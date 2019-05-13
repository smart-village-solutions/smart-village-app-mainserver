class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :addition
      t.string :city
      t.string :street
      t.string :zip
      t.integer :kind, default: 0
      t.references :addressable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
