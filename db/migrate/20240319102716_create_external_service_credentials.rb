# frozen_string_literal: true

class CreateExternalServiceCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :external_service_credentials do |t|
      t.string :client_key
      t.string :client_secret
      t.string :scopes
      t.string :auth_type
      t.string :external_id
      t.references :external_service, null: false, foreign_key: true
      t.references :data_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
