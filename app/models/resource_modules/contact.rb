# frozen_string_literal: true

# This model provides a contact object to every other resource which needs one.
class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  has_many :web_urls, as: :web_urlable, dependent: :destroy

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
