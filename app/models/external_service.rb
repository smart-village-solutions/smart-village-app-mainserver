# frozen_string_literal: true

class ExternalService < ApplicationRecord
  include MunicipalityScope

  store :resource_config, coder: JSON

  belongs_to :municipality

  has_many :external_service_credential, dependent: :restrict_with_error
  has_many :data_providers, through: :external_service_credential
  has_many :external_service_categories, dependent: :restrict_with_error

  accepts_nested_attributes_for :external_service_categories
end

# == Schema Information
#
# Table name: external_services
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  base_uri        :string(255)
#  resource_config :text(65535)
#  municipality_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
