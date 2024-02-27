# frozen_string_literal: false

module Mutations
  class RedeemQuotaOfVoucher < BaseMutation
    argument :voucher_id, GraphQL::Types::ID, required: true
    argument :member_id, GraphQL::Types::ID, required: true
    argument :device_token, String, required: false
    argument :quantity, Integer, required: true

    type Types::StatusType

    def resolve(voucher_id:, member_id:, _device_token: nil, quantity:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
      return error_status("Quantity must be greater than 0", 405) if quantity <= 0

      voucher = GenericItem.where(generic_type: "Voucher").find_by(id: voucher_id)
      return error_status("Voucher not found", 404) unless voucher.present?

      # Security Check - Only allow redemptions for vouchers that are associated with a accessable POI
      poi = PointOfInterest.filtered_for_current_user(context[:current_user]).find_by(id: voucher.generic_itemable_id)
      return error_status("Voucher not found", 404) unless poi.present?

      # check if voucher has quota defined
      quota = voucher.quota
      return error_status("Voucher has no quota defined", 404) unless quota.present?

      # check if voucher has available quota for given member
      unless quota.available_quota_for_redemption_valid?(member_id, quantity)
        return error_status("Voucher has no available quota", 405)
      end

      # Zur Sicherheit nochmal prüfen, ob der Member das Device hat
      member = Member.find_by(id: member_id)
      return error_status("Member not found", 404) unless member.present?

      # Deaktiviert bis klar ist, wie wir mit Membern umgehen wollen,
      # die keine PushNotifications haben wollen
      # if member.notification_devices.where(token: device_token).blank?
      #   return error_status("Member has no device with given token", 403)
      # end

      begin
        quota.redeem!(member_id, quantity)
        OpenStruct.new(id: 1, status: "#{quantity} contingent successfully redeemed", status_code: 200)
      rescue => e
        error_status("Error on redemption: #{e}", 500)
      end
    end

    private

      # 500 Internal Server Error
      # 405 Method Not Allowed
      # 404 Not Found
      # 403 Forbidden
      def error_status(description, status_code = 403)
        OpenStruct.new(id: nil, status: description, status_code: status_code)
      end
  end
end
