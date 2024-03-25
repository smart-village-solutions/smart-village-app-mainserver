# frozen_string_literal: true

class AddAdditionalParamsToExternalServiceCredentials < ActiveRecord::Migration[6.1]
  def change
    add_column :external_service_credentials, :additional_params, :text
  end
end
