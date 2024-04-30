# frozen_string_literal: true

class AddAuthPathToExternalServices < ActiveRecord::Migration[6.1]
  def change
    add_column :external_services, :auth_path, :string
  end
end
