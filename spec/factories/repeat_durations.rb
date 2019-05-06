FactoryBot.define do
  factory :repeat_duration do
    start_date { "2019-05-03" }
    end_date { "2019-05-03" }
    every_year { false }
  end
end

# == Schema Information
#
# Table name: repeat_durations
#
#  id              :bigint           not null, primary key
#  start_date      :date
#  end_date        :date
#  every_year      :boolean
#  updated_at_tmb  :datetime
#  event_record_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
