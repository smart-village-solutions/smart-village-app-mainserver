# frozen_string_literal: true

class ExternalServiceCredential < ApplicationRecord
  store :additional_params,
        accessors: %i[organization_id],
        coder: JSON

  belongs_to :external_service
  belongs_to :data_provider
end
