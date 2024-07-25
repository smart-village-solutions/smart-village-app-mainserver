# frozen_string_literal: true

# Service to create recurring dates for an event based on its recurring pattern
class RecurringDatesForEventService
  def initialize(event)
    @event_id = event.id
    @date_start = event.dates.first.date_start
    @date_end = event.dates.first.date_end
    @time_start = event.dates.first.time_start
    @time_end = event.dates.first.time_end
    @weekdays = event.recurring_weekdays.map(&:to_i)
    @type = event.recurring_type # 0 - daily, 1 - weekly, 2 - monthly, 3 - yearly
    @interval = event.recurring_interval
  end

  def create_with_pattern
    case @type
    when 0
      create_daily_events
    when 1
      create_weekly_events
    when 2
      create_monthly_events
    when 3
      create_yearly_events
    end
  end

  private

    # create a date for all appointments between `date_start` and `date_end` based on the days
    # interval
    def create_daily_events
      while @date_start <= @date_end
        create_date
        @date_start += @interval.days
      end
    end

    # create a date for all appointments between `date_start` and `date_end` based on the weeks
    # interval considering the weekdays in each week
    def create_weekly_events
      beginning_of_week = @date_start.beginning_of_week

      while beginning_of_week <= @date_end
        @weekdays.each do |weekday|
          next unless (beginning_of_week + weekday.days) >= @date_start
          next unless (beginning_of_week + weekday.days) <= @date_end

          @date_start = beginning_of_week + weekday.days
          create_date
        end

        beginning_of_week += @interval.weeks
      end
    end

    # create a date for all appointments between `date_start` and `date_end` based on the months
    # interval
    def create_monthly_events
      while @date_start <= @date_end
        create_date
        @date_start += @interval.months
      end
    end

    # create a date for all appointments between `date_start` and `date_end` based on the years
    # interval
    def create_yearly_events
      while @date_start <= @date_end
        create_date
        @date_start += @interval.years
      end
    end

    def create_date
      FixedDate.create(
        date_start: @date_start,
        date_end: @date_start,
        time_start: @time_start,
        time_end: @time_end,
        dateable_type: "EventRecord",
        dateable_id: @event_id
      )
    end
end
