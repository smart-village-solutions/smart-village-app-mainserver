# frozen_string_literal: true

class Lunch < ApplicationRecord
  belongs_to :point_of_interest

  has_many :dates, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_many :lunch_offers, dependent: :destroy

  accepts_nested_attributes_for :dates, :lunch_offers

  scope :in_date_range, lambda { |start_date, end_date|
    fixed_date_ids = FixedDate.joins("INNER JOIN lunches ON lunches.id = fixed_dates.dateable_id")
                       .where(dateable_type: "Lunch")
                       .where.not(date_start: nil)
                       .where("(date_start <= :end_date) AND (COALESCE(date_end, date_start) >= :start_date)", start_date: start_date, end_date: end_date)
                       .pluck(:id)

    joins(:dates).where(fixed_dates: { id: fixed_date_ids })
  }

  scope :upcoming, lambda {
    upcoming_lunch_ids = Lunch.all.select do |lunch|
      lunch.list_date.try(:to_time).to_i >= Date.today.to_time.to_i
    end.map(&:id)

    where(id: upcoming_lunch_ids)
  }

  def list_date
    lunch_dates = dates.order(date_start: :asc)
    dates_count = lunch_dates.count

    return if dates_count.zero?

    future_lunches = lunch_dates.select do |date|
      date.date_start.try(:to_time).to_i >= Time.zone.now.beginning_of_day.to_i
    end
    future_date = future_lunches.first.try(:date_start)

    return future_date if future_date.present?

    return today_in_time_range(lunch_dates.first) if dates_count == 1

    lunch_dates.last.try(:date_start)
  end

  private

    # need to check start and end date and return "today" if there is only one date.
    # per CMS only one date can be saved.
    # if a start and end date describes a larger time range, "today" needs to be returned until end
    # is reached.
    def today_in_time_range(date)
      start_date = date.date_start
      end_date = date.date_end
      today = Time.zone.now.beginning_of_day

      # return start date if there is no end date
      return start_date if end_date.blank?

      # return start date if the end date is in the past
      return start_date if end_date < today

      # return "today" if there is a future end date
      today.to_date
    end
end

# == Schema Information
#
# Table name: lunches
#
#  id                           :bigint           not null, primary key
#  text                         :text(65535)
#  point_of_interest_id         :integer
#  point_of_interest_attributes :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
