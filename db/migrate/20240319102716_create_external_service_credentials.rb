# frozen_string_literal: true

class CreateExternalServiceCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :external_service_credentials do |t|
      t.text :client_key
      t.text :client_secret
      t.string :scopes
      t.string :auth_type
      t.text :external_id
      t.references :external_service, null: false, foreign_key: true
      t.references :data_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
