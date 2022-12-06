# frozen_string_literal: true

class GenericItem::Message < ApplicationRecord
  after_create :new_message_for_entry

  belongs_to :generic_item

  private

    def new_message_for_entry
      NoticeboardMailer.new_message_for_entry(self).deliver_later
    end
end

# == Schema Information
#
# Table name: generic_item_messages
#
#  id               :bigint           not null, primary key
#  generic_item_id  :integer
#  visible          :boolean          default(TRUE)
#  message          :text(65535)
#  name             :string(255)
#  email            :string(255)
#  phone_number     :string(255)
#  terms_of_service :boolean          default(FALSE)
#
