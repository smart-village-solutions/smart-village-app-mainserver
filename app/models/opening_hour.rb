# == Schema Information
#
# Table name: opening_hours
#
#  id          :bigint(8)        not null, primary key
#  weekday     :string(255)
#  date_from   :datetime
#  date_to     :datetime
#  time_from   :string(255)
#  time_to     :string(255)
#  sort_number :integer
#  open        :boolean
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OpeningHour < ApplicationRecord
  belongs_to :openingable, polymorphic: true
end
