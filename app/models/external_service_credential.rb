# frozen_string_literal: true

class ExternalServiceCredential < ApplicationRecord
  belongs_to :external_service
  belongs_to :data_provider
end
