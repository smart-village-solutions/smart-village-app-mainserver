FactoryBot.define do
  factory :opening_hour do
    weekday { "MyString" }
    date_from { "2019-04-25 17:27:48" }
    date_to { "2019-04-25 17:27:48" }
    time_from { "MyString" }
    time_to { "MyString" }
    sort_number { 1 }
    open { false }
    description { "MyString" }
  end
end

# == Schema Information
#
# Table name: opening_hours
#
#  id               :bigint           not null, primary key
#  weekday          :string(255)
#  date_from        :date
#  date_to          :date
#  time_from        :time
#  time_to          :time
#  sort_number      :integer
#  open             :boolean
#  description      :string(255)
#  openingable_type :string(255)
#  openingable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  use_year         :boolean
#
