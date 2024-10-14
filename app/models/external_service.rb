# frozen_string_literal: true

class ExternalService < ApplicationRecord
  include MunicipalityScope

  # This can be extended to support more preparer types in the future.
  PREPARER_TYPES = {
    oveda: "ExternalServices::EventRecords::OvedaPreparer"
  }.freeze

  store :resource_config, coder: JSON

  belongs_to :municipality

  has_many :external_service_credentials, dependent: :restrict_with_error
  has_many :data_providers, through: :external_service_credentials

  has_many :external_service_categories, dependent: :restrict_with_error

  accepts_nested_attributes_for :external_service_categories

  validates :preparer_type, inclusion: {
    in: PREPARER_TYPES.keys.map(&:to_s),
    message: "%{value} is not a valid preparer type"
  }, allow_blank: true

  # Extracts unique parameter names from the `resource_config` URLs.
  # This method identifies placeholders within curly braces `{}` in each URL pattern
  # and returns a list of distinct parameter names.
  #
  # @return [Array<String>] Array of unique parameter names.
  #
  # @example Usage
  #   external_service.extract_params #=> ["organization_id", "event_id", "other_param"]

  def extract_params
    raise TypeError, "Expected resource_config to be a Hash" unless valid_resource_config?

    params = fetch_params_from_resource_config
    params.uniq
  end

  def preparer_class
    PREPARER_TYPES[preparer_type.to_sym] ||
      raise(NotImplementedError, "Class does not have a preparer type(default will be used OvedaPreparer)")
  end

  private

    # if resource config is nil or not a hash, return false
    def valid_resource_config?
      resource_config.is_a?(Hash)
    end

    def fetch_params_from_resource_config
      params = []
      resource_config.each_value do |config|
        validate_config(config)
        params.concat(extract_params_from_config(config))
      end
      params
    end

    def validate_config(config)
      raise TypeError, "Expected config to be a Hash" unless config.is_a?(Hash)
    end

    def extract_params_from_config(config)
      # Define a list of parameters to ignore
      ignore_list = ["id", "%id%"]

      # Convert the list to a regex pattern that matches any of these patterns enclosed by any combination of curly braces
      ignore_pattern = ignore_list.map { |i| Regexp.escape(i) }.join("|")

      # Create a regular expression (regex) that matches placeholders in URLs, excluding those defined in the ignore list.
      # The regex does the following:
      # 1. `\{` and `\}` match the literal curly braces.
      # 2. `(?!#{ignore_pattern})` is a negative lookahead that ensures the sequence does not match any pattern in `ignore_pattern`.
      # 3. `\w+` matches one or more word characters (letters, numbers, underscores) inside the braces that are not part of the ignore list.
      regex = /\{((?!#{ignore_pattern})\w+)\}/

      params = []
      config.each_value do |url|
        matches = url.scan(regex).flatten
        params.concat(matches)
      end
      params.flatten
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
#  auth_path       :string(255)
#  preparer_type   :string(255)
#
