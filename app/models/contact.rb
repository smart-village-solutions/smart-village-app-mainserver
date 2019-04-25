class Contact < ApplicationRecord
    belongs_to :operating_company, optional: true
    belongs_to :data_provider, optional: true
    belongs_to :point_of_interest, optional: true
end
