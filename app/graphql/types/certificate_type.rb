# frozen_string_literal: true

module Types
  class CertificateType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
  end
end
