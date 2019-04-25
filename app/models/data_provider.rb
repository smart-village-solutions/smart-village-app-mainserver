class DataProvider < ApplicationRecord
    has_many :adresses
    has_many :contacts
    belongs_to :point_of_interest
end
