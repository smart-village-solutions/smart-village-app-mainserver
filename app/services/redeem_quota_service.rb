# frozen_string_literal: true

# Service to redeem a quota for a member based on quantity of available quota
class RedeemQuotaService
  def initialize(item, member_id, quantity)
    @item = item
    @member_id = member_id
    @quantity = quantity
  end

  def call
    return error_response("Quantity must be greater than 0", 405) if @quantity <= 0
    return error_response("Item not found", 404) unless @item.present?

    quota = @item.quota
    return error_response("Item has no quota defined", 404) unless quota.present?
    return error_response("Item has no available quota", 405) unless quota.available_quota_for_redemption_valid?(@member_id, @quantity)

    member = Member.find_by(id: @member_id)
    return error_response("Member not found", 404) unless member.present?

    begin
      quota.redeem!(@member_id, @quantity)
      OpenStruct.new(id: 1, status: "#{@quantity} contingent successfully redeemed", status_code: 200)
    rescue => e
      error_response("Error on redemption: #{e}", 500)
    end
  end

  private

    def error_response(description, status_code)
      OpenStruct.new(id: nil, status: description, status_code: status_code)
    end
end
