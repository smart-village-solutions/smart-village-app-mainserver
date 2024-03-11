# frozen_string_literal: true

class RenameReceiptsToMessagingReceipts < ActiveRecord::Migration[6.1]
  def up
    rename_table :receipts, :messaging_receipts
  end

  def down
    rename_table :messaging_receipts, :receipts
  end
end
