# == Schema Information
#
# Table name: opening_hours
#
#  id               :bigint(8)        not null, primary key
#  weekday          :string(255)
#  date_from        :date
#  date_to          :date
#  time_from        :time
#  time_to          :time
#  sort_number      :integer
#  open             :boolean
#  description      :string(255)
#  openingable_type :string(255)
#  openingable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class OpeningHour < ApplicationRecord
  belongs_to :openingable, polymorphic: true
end
