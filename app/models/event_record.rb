# frozen_string_literal: true

# this model describes the data for an event e.g. a concert or a reading.
class EventRecord < ApplicationRecord
  belongs_to :category
  belongs_to :region
  has_many :urls, as: :web_urlable, class_name: "WebUrl"
  has_one :data_provider, as: :provideable
  has_one :organizer, as: :companyable, class_name: "OperatingCompany"
  has_many :addresses, as: :addressable
  has_one :location, as: :locateable
  has_many :contacts, as: :contactable
  has_one :accessibility_information, as: :accessable
  has_many :price_informations, as: :priceable, class_name: "Price"
  has_many :media_contents, as: :mediaable
  has_one :repeat_duration
  has_many :dates, as: :dateable, class_name: "FixedDate"

  acts_as_taggable

  validates_presence_of :title
end

# == Schema Information
#
# Table name: event_records
#
#  id          :bigint           not null, primary key
#  parent_id   :integer
#  region      :string(255)
#  description :string(255)
#  repeat      :boolean
#  title       :string(255)
#  category_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
