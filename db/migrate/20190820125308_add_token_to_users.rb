class AddTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authentication_token, :text
    add_column :users, :authentication_token_created_at, :datetime

    add_index :users, :authentication_token, unique: true, length: 255
  end
end
