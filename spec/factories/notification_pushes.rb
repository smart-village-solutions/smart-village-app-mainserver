# frozen_string_literal: true

FactoryBot.define do
  factory :notification_push_once, class: "Notification::Push" do
    id { 1 }
    notification_pushable_type { "GenericItem" }
    notification_pushable_id { 1 }
    once_at { "2022-11-25 17:00:00" }
    recurring { 0 }
    monday_at { nil }
    tuesday_at { nil }
    wednesday_at { nil }
    thursday_at { nil }
    friday_at { nil }
    saturday_at { nil }
    sunday_at { nil }
  end

  factory :notification_push_mondays, class: "Notification::Push" do
    id { 2 }
    notification_pushable_type { "GenericItem" }
    notification_pushable_id { 2 }
    once_at { nil }
    recurring { 1 }
    monday_at { "12:00:00" }
    tuesday_at { nil }
    wednesday_at { nil }
    thursday_at { nil }
    friday_at { nil }
    saturday_at { nil }
    sunday_at { nil }
  end

  factory :notification_push_wednesdays_and_saturdays, class: "Notification::Push" do
    id { 3 }
    notification_pushable_type { "GenericItem" }
    notification_pushable_id { 3 }
    once_at { nil }
    recurring { 1 }
    monday_at { nil }
    tuesday_at { nil }
    wednesday_at { "14:00:00" }
    thursday_at { nil }
    friday_at { nil }
    saturday_at { "14:00:00" }
    sunday_at { nil }
  end
end

# == Schema Information
#
# Table name: notification_pushes
#
#  id                         :bigint           not null, primary key
#  notification_pushable_type :string(255)
#  notification_pushable_id   :bigint
#  once_at                    :datetime
#  monday_at                  :time
#  tuesday_at                 :time
#  wednesday_at               :time
#  thursday_at                :time
#  friday_at                  :time
#  saturday_at                :time
#  sunday_at                  :time
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  recurring                  :integer          default(0)
#  title                      :string(255)
#  body                       :string(255)
#  data                       :text(65535)
#
