# frozen_string_literal: true

FactoryBot.define do
  factory :event_record do
    description { "A Reading with an Author" }
    repeat { false }
    title { "MyString" }
    data_provider { create(:data_provider) }

    factory :event_record_with_dates do
      transient do
        dates_count { 5 }
      end

      after(:create) do |event_record, evaluator|
        create_list(:event_record, evaluator.dates_count, event_record: event_record)
      end
    end
  end
end

# == Schema Information
#
# Table name: event_records
#
#  id                 :bigint           not null, primary key
#  parent_id          :integer
#  region_id          :bigint
#  description        :text(65535)
#  repeat             :boolean
#  title              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  data_provider_id   :integer
#  external_id        :string(255)
#  visible            :boolean          default(TRUE)
#  recurring          :boolean          default(FALSE)
#  recurring_weekdays :string(255)
#  recurring_type     :integer
#  recurring_interval :integer
#
