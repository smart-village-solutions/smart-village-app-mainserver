class AddRecoveryToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :reset_password_token, :string
    add_column :members, :reset_password_sent_at, :datetime
    add_column :members, :unlock_token, :string

    add_index :members, :reset_password_token, unique: true
  end
end
