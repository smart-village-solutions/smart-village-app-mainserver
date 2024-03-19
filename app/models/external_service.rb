# frozen_string_literal: true

class ExternalService < ApplicationRecord
  include MunicipalityScope

  store :resource_config,
        accessors: %i[
          resource_event
          resource_poi
        ], coder: JSON

  belongs_to :municipality
  has_one :external_service_credential, dependent: :destroy
end
