# frozen_string_literal: true
# rubocop:disable all
module Mutations
  class DestroyWastePickUpTime < BaseMutation
    include RecordDestruction

    argument :ids, [ID], required: false
    argument :pickup_date, String, required: false
    argument :waste_location_type, Types::InputTypes::WasteLocationTypeInput, required: false,
              as: :waste_location_type_params,
              prepare: lambda { |address, _ctx|
                          address.to_h
                        }

    type Types::DestroyType

    def resolve(**params)
      raise "Access not permitted" unless context[:current_user].admin_role?
      validate_pickup_date(params[:pickup_date]) if params[:pickup_date].present?

      all_records_query = Waste::PickUpTime.all
      records_to_destroy = params.empty? ? all_records_query : filtered_records(all_records_query, params)

      # destroy_records come from RecordDestruction concern and return a builded response object
      # like OpenStruct.new(id: id, status: status, status_code: status_code)
      destroy_records(records_to_destroy)
    end

    private
      def validate_pickup_date(pickup_date)
        Date.parse(pickup_date)
      rescue ArgumentError
        raise GraphQL::ExecutionError, "Invalid pickup_date format. Please use valid date format 'YYYY-MM-DD' or 'DD.MM.YYYY'."
      end

      def filtered_records(query, params)
        WastePickUpTimeQuery.new(query, params).call
      end
  end
end