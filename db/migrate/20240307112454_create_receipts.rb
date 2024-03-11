# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.references :message, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
