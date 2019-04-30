# frozen_string_literal: true

class OperatingCompany < ApplicationRecord
  belongs_to :companyable, polymorphic: true
  has_many :adresses, as: :adressable
  has_many :contacts, as: :contactable

  validates_presence_of :name
end

# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint(8)        not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
