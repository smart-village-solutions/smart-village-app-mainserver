class FixedDate < ApplicationRecord
  belongs_to :dateable, polymorphic: true
end
