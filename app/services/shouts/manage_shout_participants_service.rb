# frozen_string_literal: true

module Shouts
  class ManageShoutParticipantsService
    def initialize(item, participants)
      @item = item
      @participants = participants.map(&:to_i)
    end

    def call
      manage_redemptions
    end

    private

      def manage_redemptions
        current_quota = @item.quota || @item.create_quota
        return if @participants.empty? || current_quota.blank?

        existing_participant_ids = current_quota.redemptions.pluck(:member_id)
        new_participant_ids = @participants - existing_participant_ids
        removed_participant_ids = existing_participant_ids - @participants

        add_new_redemptions(new_participant_ids, current_quota)
        remove_old_redemptions(removed_participant_ids, current_quota)
      end

      def add_new_redemptions(new_participant_ids, quota)
        new_participant_ids.each do |participant_id|
          # Ensure that redemption is associated with quota as redemable
          quota.redemptions.create(member_id: participant_id, redemable: quota)
        end
      end

      def remove_old_redemptions(removed_participant_ids, quota)
        quota.redemptions.where(member_id: removed_participant_ids).destroy_all
      end
  end
end
