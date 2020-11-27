# frozen_string_literal: true

class Notification::Device < ApplicationRecord
  enum device_type: { undefined: 0, ios: 1, android: 2 }

  # Zusätzlich zu der Validierung hier existiert auch ein unique Index auf das Feld 'token'
  validates_uniqueness_of :token, on: :create, message: "must be unique"
  validates_presence_of :token, on: :create, message: "can't be blank"
end
