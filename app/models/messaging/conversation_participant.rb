# frozen_string_literal: true

class Messaging::ConversationParticipant < ApplicationRecord
  belongs_to :conversation, class_name: "Messaging::Message"
  belongs_to :member
end
