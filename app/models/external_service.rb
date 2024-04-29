# frozen_string_literal: true

class ExternalService < ApplicationRecord
  include MunicipalityScope

  store :resource_config, coder: JSON

  belongs_to :municipality

  has_many :external_service_credentials, dependent: :restrict_with_error
  has_many :data_providers, through: :external_service_credentials

  has_many :external_service_categories, dependent: :restrict_with_error

  accepts_nested_attributes_for :external_service_categories

  # Extracts unique parameter names from the `resource_config` URLs.
  # This method identifies placeholders within curly braces `{}` in each URL pattern
  # and returns a list of distinct parameter names.
  #
  # @return [Array<String>] Array of unique parameter names.
  #
  # @example Usage
  #   external_service.extract_params #=> ["organization_id", "event_id", "other_param"]
  def extract_params
    params = []
    resource_config.each_value do |config|
      config.each_value do |url|
        # This line extracts parameters enclosed in curly braces from the URL,
        # adds them to the params array, and flattens the nested arrays into a single array.
        params.concat(url.scan(/\{(\w+)\}/).flatten)
      end
    end
    params.uniq
  end
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
