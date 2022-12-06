# frozen_string_literal: true

class CreateGenericItemMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :generic_item_messages do |t|
      t.integer :generic_item_id
      t.boolean :visible, default: true
      t.text :message
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :terms_of_service, default: false
    end
  end
end
