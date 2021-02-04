class CreateLunches < ActiveRecord::Migration[5.2]
  def change
    create_table :lunches do |t|
      t.text :text
      t.integer :point_of_interest_id
      t.string :point_of_interest_attributes

      t.timestamps
    end
  end
end
