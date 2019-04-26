# == Schema Information
#
# Table name: point_of_interests
#
#  id                 :bigint(8)        not null, primary key
#  external_id        :integer
#  name               :string(255)
#  description        :string(255)
#  mobile_description :string(255)
#  active             :boolean
#  thumbnail_url      :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PointOfInterest < ApplicationRecord
    has_many :adresses, as: :adressable
    has_many :contacts, as: :contactable
    has_one :operating_company, as: :companyable
    has_one :data_provider, as: :provideable
    has_many :prices, as: :priceable
    has_many :media_contents, as: :mediable
    has_many :opening_hours, as: :openingable
    has_many :accessibilty_informations, as: :accessable
    has_many :certificates
    has_one :thumbnail_url, as: :web_urlable
end
