# frozen_string_literal: true

class Certificate < ApplicationRecord
  belongs_to :attraction

  validates_presence_of :name
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  attraction_id :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
