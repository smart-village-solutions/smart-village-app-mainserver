# frozen_string_literal: true

class WasteNotification
  attr_accessor :client, :message_options, :check_date, :waste_types

  def initialize(check_date = Date.today)
    @check_date = check_date
  end

  def send_notifications
    all_waste_registrations = Waste::DeviceRegistration.all

    # Load all possible addresses for registered push notifications
    possible_address_ids = Address.joins(:waste_location_types).where(
      street: all_waste_registrations.pluck(:street),
      city: all_waste_registrations.pluck(:city),
      zip: all_waste_registrations.pluck(:zip)
    ).pluck(:id)

    # Load all PickupTimes of next couple days
    number_of_days = all_waste_registrations.pluck(:notify_days_before).uniq
    date_span = dates_to_check(number_of_days)
    waste_pickup_time_ids_of_next_days = Waste::PickUpTime.where(pickup_date: date_span).pluck(:id)

    # load all Waste::LocationType in given addresses and timespan
    waste_pickup_times = Waste::PickUpTime
                           .includes(:waste_location_type)
                           .where(id: waste_pickup_time_ids_of_next_days)
                           .where(waste_location_types: { address_id: possible_address_ids })

    all_waste_registrations.each do |registration_to_check|
      waste_pickup_times.each do |waste_pickup_time|
        next unless matching_address_and_type(waste_pickup_time, registration_to_check)
        next unless (check_date + registration_to_check.notify_days_before.days) == waste_pickup_time.pickup_date
        next if registration_to_check.blank?
        next if waste_pickup_time.blank?

        # this way we can convert times, that are given as winter because of `time` database field,
        # which serves on first of january, to the local time zone to correct it to summertime
        # if it is summer
        date_time_to_run = Time.zone.parse("#{check_date} #{registration_to_check.notify_at.to_s(:time)}")
        p "Registration Found for Waste::LocationType: #{waste_pickup_time.waste_location_type.id}, #{registration_to_check.id} on #{waste_pickup_time.pickup_date}"
        p "Run at: #{date_time_to_run}"

        # Look for existing Notification
        existing_notifications_count = Delayed::Backend::ActiveRecord::Job
                                         .where("handler LIKE '%WasteNotificationJob%'")
                                         .where("handler LIKE '%args:\n- #{registration_to_check.id}\n- #{waste_pickup_time.id}%'")
                                         .count
        next if existing_notifications_count.positive?

        # Send Notification
        WasteNotificationJob.delay(run_at: date_time_to_run).perform(registration_to_check.id, waste_pickup_time.id)
      end
    end

    "Notifications send by delayed_job"
  end

  def matching_address_and_type(waste_pickup_time, registration_to_check)
    wlt_address = waste_pickup_time.waste_location_type.address

    wlt_address.street == registration_to_check.street &&
      wlt_address.city == registration_to_check.city &&
      wlt_address.zip == registration_to_check.zip &&
      waste_pickup_time.waste_location_type.waste_type == registration_to_check.notify_for_waste_type
  end

  # Alle Tage, die überprüft werden müssen
  #
  # @param [Array<Integer>] number_of_days
  # Die Anzahl der Tage, die eine Benachrichtigung vor einem Abholtag vorzeitig versendet werden soll.
  #
  # @return [Array<Date>] Liste an Datumseinträgen die für eine Abholung in Frage kommen
  def dates_to_check(number_of_days)
    all_days = [check_date]
    number_of_days.sort.each do |days_before|
      all_days << check_date + days_before.days
    end

    all_days.uniq
  end
end
