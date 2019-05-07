# frozen_string_literal: true

# This model provides an adress to every other resource which needs one.
class Adress < ApplicationRecord
  belongs_to :adressable, polymorphic: true
  has_one :geo_location, as: :geo_locateable
  enum kind: [default: 0, start: 1, end: 2]
end

# == Schema Information
#
# Table name: adresses
#
#  id              :bigint           not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  adressable_type :string(255)
#  adressable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
