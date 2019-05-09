# frozen_string_literal: true

class Certificate < ApplicationRecord
  has_and_belongs_to_many :attractions, optional: true

  validates_presence_of :name
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  point_of_interest_id :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
