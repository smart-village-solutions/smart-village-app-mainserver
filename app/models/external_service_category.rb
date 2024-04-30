# frozen_string_literal: true

class ExternalServiceCategory < ApplicationRecord
  belongs_to :external_service
  belongs_to :category

  validates :external_id, uniqueness: { scope: :external_service_id, allow_blank: true }, if: -> { external_id.present? }
end
