# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventRecord, type: :model do
  let(:event_record_2) { create(:event_record) }
  let(:event_record_1) { create(:event_record) }

  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_many(:contacts) }
  it { is_expected.to have_one(:organizer) }
  it { is_expected.to belong_to(:data_provider) }
  it { is_expected.to have_many(:price_informations) }
  it { is_expected.to have_many(:media_contents) }
  it { is_expected.to have_one(:location) }
  it { is_expected.to have_one(:repeat_duration) }
  it { is_expected.to have_one(:accessibility_information) }
  it { is_expected.to have_many(:urls) }
  it { is_expected.to have_many(:dates) }
  it { is_expected.to validate_presence_of(:title) }

  def create_date(date_start, date_end)
    FixedDate.create(
      weekday: Faker::Date.between(2000.days.ago, Date.today).strftime("%A"),
      date_start: date_start,
      date_end: date_end,
      time_start: Faker::Time.backward.strftime("%H:%M"),
      time_end: Faker::Time.forward.strftime("%H:%M"),
      time_description: Faker::Lorem.paragraph,
      use_only_time_description: Faker::Boolean.boolean(0.8)
    )
  end

  def add_date_to(event_record, date_start = Time.zone.now, date_end = Time.zone.now)
    event_record.dates << create_date(date_start, date_end)

    event_record.save
  end

  describe "#list_date" do
    context "with an event which has two future dates" do
      it "returns the date closest to now" do
        er_1 = event_record_1
        future_date_1 = "21.12.2100"
        future_date_2 = "21.12.2101"
        add_date_to(er_1, future_date_1)
        add_date_to(er_1, future_date_2)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(future_date_1)
      end
    end

    context "with an event who has two past dates" do
      it "returns the date closest to now" do
        er_1 = event_record_1
        past_date_1 = "20.12.2018"
        past_date_2 = "21.05.2019"
        add_date_to(er_1, past_date_1)
        add_date_to(er_1, past_date_2)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(past_date_2)
      end
    end

    context "with an event which has a past and two future date" do
      it "returns the future date which is closest to now" do
        er_1 = event_record_1
        future_date_1 = "21.12.2100"
        future_date_2 = "21.12.2101"
        past_date = "21.05.2019"
        add_date_to(er_1, future_date_1)
        add_date_to(er_1, future_date_2)
        add_date_to(er_1, past_date)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(future_date_1)
      end
    end

    context "with an event which has a past start date and a future end date" do
      it "returns todays date" do
        er_1 = event_record_1
        past_date = "12.05.2020"
        future_date = "20.09.2100"
        add_date_to(er_1, past_date, future_date)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(Time.zone.now.strftime("%d.%m.%Y"))
      end
    end

    context "with an event which has a past start date and a past end date" do
      it "returns past date" do
        er_1 = event_record_1
        past_date = "12.05.2020"
        add_date_to(er_1, past_date, past_date)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(past_date)
      end
    end

    context "with an event which has a future start date and a future end date" do
      it "returns start date" do
        er_1 = event_record_1
        start_date = "12.05.2100"
        end_date = "12.07.2100"
        add_date_to(er_1, start_date, end_date)
        result = er_1.list_date.strftime("%d.%m.%Y")
        expect(result).to eq(start_date)
      end
    end

    context "without an event" do
      it "returns nil" do
        result = event_record_1.list_date
        expect(result).to be_nil
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
