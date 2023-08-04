# frozen_string_literal: true

class RecurringDatesForEventService
  def initialize(event)
    @event_id = event.id
    @date_start = event.dates.first.date_start
    @date_end = event.dates.first.date_end
    @time_start = event.dates.first.time_start
    @time_end = event.dates.first.time_end
    @weekdays = event.recurring_weekdays
    @type = event.recurring_type # 0 - daily, 1 - weekly, 2 - monthly, 3 - yearly
    @interval = event.recurring_interval
  end

  def create_with_pattern
    case @type
    when 0
      create_daily_events
    when 1
      # TODO: create_weekly_events
    when 2
      # TODO: create_monthly_events
    when 3
      # TODO: create_yearly_events
    end
  end

  private

    # create a date for all appointments between date_start and date_end based on the days interval
    def create_daily_events
      while @date_start <= @date_end
        create_date(
          date_start: @date_start,
          date_end: @date_start,
          time_start: @time_start,
          time_end: @time_end
        )

        @date_start += @interval.days
      end
    end

    def create_date(params)
      FixedDate.create(
        params.merge(
          dateable_type: "EventRecord",
          dateable_id: @event_id
        )
      )
    end
end
