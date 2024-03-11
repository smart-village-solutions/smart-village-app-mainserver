# frozen_string_literal: true

class Messaging::Receipt < ApplicationRecord
  belongs_to :message, class_name: "Messaging::Message"
  belongs_to :member
end


# == Schema Information
#
# Table name: messaging_receipts
#
#  id         :bigint           not null, primary key
#  message_id :bigint           not null
#  member_id  :bigint           not null
#  read       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#