# frozen_string_literal: false

# Filter by data provider and point of interest scopes, which will allow us to build exclusion filter by do and poi ids
module FilterByDataProviderAndPoiScope
  extend ActiveSupport::Concern

  included do
    scope :for_data_provider, lambda { |data_provider|
      return none if data_provider.blank?

      where.not(data_provider: nil).where(data_provider: data_provider)
    }

    scope :for_point_of_interest, lambda { |point_of_interest|
      return none if point_of_interest.blank?

      where.not(point_of_interest: nil).where(point_of_interest: point_of_interest)
    }

    scope :by_data_provider_or_poi, lambda { |data_provider, point_of_interest|
      for_data_provider(data_provider).or(for_point_of_interest(point_of_interest)) if data_provider.present? || point_of_interest.present?
    }
  end
end
