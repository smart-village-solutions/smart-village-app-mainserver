# frozen_string_literal: true

class Certificate < ApplicationRecord
  belongs_to :point_of_interest

  validates_presence_of :name
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string(255)
#  point_of_interest_id :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
