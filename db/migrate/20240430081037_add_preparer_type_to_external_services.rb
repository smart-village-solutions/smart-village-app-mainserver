# frozen_string_literal: true

class AddPreparerTypeToExternalServices < ActiveRecord::Migration[6.1]
  def change
    add_column :external_services, :preparer_type, :string
  end
end
