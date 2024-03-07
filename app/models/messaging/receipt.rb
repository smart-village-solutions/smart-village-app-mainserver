# frozen_string_literal: true

class Messaging::Receipt < ApplicationRecord
  belongs_to :message, class_name: "Messaging::Message"
  belongs_to :member
end
