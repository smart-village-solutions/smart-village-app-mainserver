# frozen_string_literal: false

module Mutations
  class RedeemQuotaOfVoucher < BaseMutation
    argument :voucher_id, GraphQL::Types::ID, required: true
    argument :member_id, GraphQL::Types::ID, required: true
    argument :device_token, String, required: false
    argument :quantity, Integer, required: true

    type Types::StatusType

    def resolve(voucher_id:, member_id:, device_token: nil, quantity:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
      voucher = GenericItem.where(generic_type: "Voucher").find_by(id: voucher_id)

      # Security Check - Only allow redemptions for vouchers that are associated with a accessable POI
      poi = PointOfInterest.filtered_for_current_user(context[:current_user]).find_by(id: voucher.generic_itemable_id)
      return error_status("Voucher not found", 404) unless poi.present?

      RedeemQuotaService.new(voucher, member_id, quantity, device_token).call
    end
  end
end