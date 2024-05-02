# frozen_string_literal: false

module Mutations
  class RedeemQuotaOfAnnouncement < BaseMutation
    argument :announcement_id, GraphQL::Types::ID, required: true
    argument :member_id, GraphQL::Types::ID, required: true
    argument :quantity, Integer, required: true

    type Types::StatusType

    def resolve(announcement_id:, member_id:, quantity:)
      announcement = GenericItem.announcements_type.find_by(id: announcement_id)
      RedeemQuotaService.new(announcement, member_id, quantity).call
    end
  end
end
