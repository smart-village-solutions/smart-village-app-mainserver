class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :keycloak_id
      t.integer :municipality_id

      t.timestamps
    end
  end
end
