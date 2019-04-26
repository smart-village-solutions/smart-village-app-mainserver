# frozen_string_literal: true
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

class OperatingCompany < ApplicationRecord
  has_many :adresses, as: :adressable
  has_many :contacts, as: :contactable
  belongs_to :companyable, polymorphic: true
end
