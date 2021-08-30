# frozen_string_literal: true

FactoryBot.define do
  factory :fixed_date do
    date_start { "2019-05-06" }
    date_end { "2019-05-06" }
    weekday { "MyString" }
    time_start { "2019-05-06 12:17:44" }
    time_end { "2019-05-06 12:17:44" }
    time_description { "MyString" }
    use_only_time_description { false }
  end
end

# == Schema Information
#
# Table name: fixed_dates
#
#  id                        :bigint           not null, primary key
#  date_start                :date
#  date_end                  :date
#  weekday                   :string(255)
#  time_start                :time
#  time_end                  :time
#  time_description          :text(65535)
#  use_only_time_description :boolean          default(FALSE)
#  dateable_type             :string(255)
#  dateable_id               :bigint
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
