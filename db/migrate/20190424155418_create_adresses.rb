class CreateAdresses < ActiveRecord::Migration[5.2]
  def change
    create_table :adresses do |t|
      t.string :addition
      t.string :city
      t.string :street
      t.string :zip

      t.timestamps
    end
  end
end
