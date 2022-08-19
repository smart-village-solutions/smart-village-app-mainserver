class FixUniquenessOfEmailInUsers < ActiveRecord::Migration[6.0]
  def change
    remove_index "users", name: "index_users_on_email"
    add_index :users, [:email, :municipality_id], name: 'index_email_on_municipality_id', unique: false
  end
end
