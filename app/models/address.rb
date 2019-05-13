# frozen_string_literal: true

# This model provides an address to every other resource which needs one.
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  has_one :geo_location, as: :geo_locateable
  enum kind: { default: 0, start: 1, end: 2 }, _prefix: :kind_of?
end

# == Schema Information
#
# Table name: addresses
#
#  id              :bigint           not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  kind            :integer          default("default")
#  addressable_type :string(255)
#  addressable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
