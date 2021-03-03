# frozen_string_literal: true

class WasteNotification
  attr_accessor :client, :message_options, :check_date, :waste_types

  def initialize(check_date = Date.today)
    @check_date = check_date
  end

  def send_notifications
    all_waste_registrations = Waste::DeviceRegistration.all
    # Waste::LocationType

    # Load all possible addresses for registered push notifications
    possible_addresses = Address.joins(:waste_location_types).where(
      street: all_waste_registrations.pluck(:street),
      city: all_waste_registrations.pluck(:city),
      zip: all_waste_registrations.pluck(:zip)
    )
    # possible_addresses

    # Load all PickupTimes of next couple days
    number_of_days = all_waste_registrations.pluck(:notify_days_before).uniq
    date_span = dates_to_check(number_of_days)
    pickup_times = Waste::PickUpTime.where(pickup_date: date_span)

    # load all Waste::LocationType in given addreses and timespan
    waste_pickup_times = Waste::PickUpTime
                             .includes(:waste_location_type)
                             .where(id: pickup_times.map(&:id))
                             .where(waste_location_types: { address_id: possible_addresses.map(&:id) })

    all_waste_registrations.each do |registration_to_check|
      waste_pickup_times.each do |waste_pickup_time|
        next unless matching_address_and_type(waste_pickup_time, registration_to_check)
        next unless (check_date + registration_to_check.notify_days_before.days) == waste_pickup_time.pickup_date

        p "Registration Found for Waste::LocationType: #{waste_pickup_time.waste_location_type.id}, #{registration_to_check.id} on #{waste_pickup_time.pickup_date}"

        # Send Notification
        Delayed::Job.enqueue(
          WasteNotificationJob.new(registration_to_check.id, waste_pickup_time.id),
          run_at: DateTime.parse("#{check_date} #{registration_to_check.notify_at_time}")
        )
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

  def dates_to_check(number_of_days)
    all_days = [@check_date]
    number_of_days.sort.each do |days_before|
      all_days << @check_date + days_before.days
    end

    all_days.uniq
  end
end
