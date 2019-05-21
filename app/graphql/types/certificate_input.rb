# frozen_string_literal: true

module Types
  class CertificateInput < BaseInputObject
    argument :name, String, required: true
  end
end