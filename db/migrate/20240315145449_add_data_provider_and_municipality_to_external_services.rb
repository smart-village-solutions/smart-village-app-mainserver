# frozen_string_literal: true

class AddDataProviderAndMunicipalityToExternalServices < ActiveRecord::Migration[6.1]
  def change
    add_column :external_services, :data_provider_id, :bigint
    add_column :external_services, :municipality_id, :integer
  end
end
