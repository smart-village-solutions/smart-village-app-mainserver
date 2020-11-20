# frozen_string_literal: true

class Notification::Device < ApplicationRecord
  enum device_type: { undefined: 0, ios: 1, android: 2 }

  validates_uniqueness_of :token, on: :create, message: "must be unique"
end
