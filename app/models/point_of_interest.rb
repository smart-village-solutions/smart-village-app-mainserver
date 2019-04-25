class PointOfInterest < ApplicationRecord
    has_many :adresses
    has_many :contacts
    has_one :operating_company
    has_one :data_provider
    has_many :prices
    has_many :media_contents
    has_many :opening_hours
end