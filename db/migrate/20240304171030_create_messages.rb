class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.text :message_text

      t.timestamps
    end
  end
end
