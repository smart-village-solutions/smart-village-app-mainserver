# frozen_string_literal: true

class AccessibilityInformation < ApplicationRecord
  belongs_to :accessable, polymorphic: true
  has_many :urls, as: :web_urlable, class_name: "WebUrl", dependent: :destroy

  accepts_nested_attributes_for :urls, reject_if: ->(attr) { attr[:url].blank? }
end

# == Schema Information
#
# Table name: accessibility_informations
#
#  id              :bigint           not null, primary key
#  description     :text(65535)
#  types           :string(255)
#  accessable_type :string(255)
#  accessable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
