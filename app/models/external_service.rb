# frozen_string_literal: true

class ExternalService < ApplicationRecord
  include MunicipalityScope

  store :resource_config, coder: JSON

  belongs_to :municipality
  has_one :external_service_credential, dependent: :restrict_with_error
  has_many :data_providers, through: :external_service_credential
end
