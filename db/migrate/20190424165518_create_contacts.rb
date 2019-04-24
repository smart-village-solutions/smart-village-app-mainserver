class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :fax
      t.string :email
      t.string :url

      t.timestamps
    end
  end
end
