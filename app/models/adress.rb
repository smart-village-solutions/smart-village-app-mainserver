class Adress < ApplicationRecord
  has_one :geo_location
  belongs_to :point_of_interests, optional: true
  belongs_to :operating_company, optional: true
  belongs_to :data_provider, optional: true
end
