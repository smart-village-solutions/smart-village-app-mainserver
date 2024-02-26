# frozen_string_literal: true

# Class for querying waste pick up times by different filters
# Waste::PickUpTime.all will return all records with current municipality based on MunicipalityService.municipality_id
class WastePickUpTimeQuery
  def initialize(scope = Waste::PickUpTime.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    apply_filters
  end

  private

    attr_reader :scope, :params

    def apply_filters
      scope = filter_by_id(@scope, params[:ids])
      scope = filter_by_pick_up_date(scope, params[:pickup_date])
      filter_by_waste_location_type(scope, params[:waste_location_type_params])
    end

    def filter_by_id(scope, record_ids)
      return scope unless record_ids.present?

      scope.where(id: record_ids)
    end

    def filter_by_pick_up_date(scope, pickup_date)
      return scope unless pickup_date.present?

      scope.where(pickup_date: Date.parse(pickup_date))
    end

    def filter_by_waste_location_type(scope, waste_location_type_params)
      return scope unless waste_location_type_params.present?

      scope = filter_by_waste_type(scope, waste_location_type_params[:waste_type])
      filter_by_address(scope, waste_location_type_params[:address_attributes])
    end

    def filter_by_waste_type(scope, waste_type)
      return scope unless waste_type.present?

      scope.joins(:waste_location_type).where(waste_location_types: { waste_type: waste_type })
    end

    def filter_by_address(scope, address)
      return scope unless address.present?

      scope.joins(waste_location_type: :address).where(addresses: address.to_h)
    end
end
