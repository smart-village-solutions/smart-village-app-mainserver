class Region < ApplicationRecord
  belongs_to :regionable, polymorphic: true
  has_one :location
end
