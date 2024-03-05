# frozen_string_literal: true

class Messaging::Message < ApplicationRecord
  belongs_to :conversation, class_name: "Messaging::Conversation"
  belongs_to :member
end
