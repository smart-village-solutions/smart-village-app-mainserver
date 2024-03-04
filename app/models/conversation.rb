# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
end
