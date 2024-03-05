class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :message_text
      t.bigint :sender_id, null: false

      t.timestamps
    end

    add_foreign_key :messages, :members, column: :sender_id
  end
end
