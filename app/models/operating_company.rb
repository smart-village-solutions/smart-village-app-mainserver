# frozen_string_literal: true

class OperatingCompany < ApplicationRecord
  belongs_to :companyable, polymorphic: true
  has_one :address, as: :addressable, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy

  accepts_nested_attributes_for :contact, :address
  validates_presence_of :name
end

# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
