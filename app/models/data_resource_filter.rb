# frozen_string_literal: true

class DataResourceFilter < ApplicationRecord
  include MunicipalityScope

  store :config,
        coder: JSON

  belongs_to :municipality
  validates :data_resource_type, presence: true
  validate :resource_filter_configs

  # Validiert, ob die angegebenen Filterconfigs für das gegebene Datenmodell zulässig sind.
  #
  # @return [void]
  def resource_filter_configs
    model = data_resource_type.constantize
    available_filters = model.available_filters.map(&:to_s)

    config.each do |filter_name, filter_attributes|
      next if available_filters.include?(filter_name)

      errors.add(
        :filters,
        "enthält ungültigen Filter für #{data_resource_type}: #{filter_name}"
      )

      validate_filter_attributes(filter_name, filter_attributes)
    end
  rescue NameError => e
    errors.add(:data_resource_type, "ist kein gültiges Datenmodell: #{e}")
  end

  private

    # Validiert die zusätzlichen Attribute eines Filters
    #
    # @param [String] filter_name - Name des Filters
    # @param [Hash] attributes - Zusätzliche Attribute des Filters
    #
    # @return [void]
    def validate_filter_attributes(_filter_name, _attributes)
      # TODO: Add Validations defined in DataResourceFilterServices::AttributeService

      # case filter_name
      # when "category"
      #   p attributes
      #   # if attributes["max_selection"].present? && !attributes["max_selection"].is_a?(Integer)
      #   errors.add(:filters, "Attribut 'max_selection' für 'category' muss eine Zahl sein")
      # end
      # when "location"
      # if attributes["radius"].present? && !attributes["radius"].is_a?(Numeric)
      #   errors.add(:filters, "Attribut 'radius' für 'location' muss numerisch sein")
      # end
      # Weitere Filter und ihre spezifischen Validierungen können hier hinzugefügt werden
      # end
    end
end

# == Schema Information
#
# Table name: data_resource_filters
#
#  id                 :bigint           not null, primary key
#  data_resource_type :string(255)
#  municipality_id    :integer
#  config             :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
