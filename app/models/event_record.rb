class EventRecord < ApplicationRecord
    has_many :urls, as: :web_urlable, class_name: "WebUrl"
    has_one :data_provider, as: :providable
    has_one :organizer, as: :companyable, class_name: "OperatingCompany"
    has_one :adress, as: :adressable
    has_one :location, as: :locateable
    has_one :contact, as: :contactable
    has_one :accessibilty_information, as: :accessable
    has_many :price_informations, as: :priceable, class_name: "Price"
    # TODO repeat duration
    # TODO highlights
    # TODO association to category
end
