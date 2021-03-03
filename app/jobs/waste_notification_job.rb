class WasteNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(waste_registration_id, waste_pickup_time_id)
    waste_pickup_time = Waste::PickUpTime.find_by(id: waste_pickup_time_id)
    registration_to_check = Waste::DeviceRegistration.find_by(id: waste_registration_id)
    waste_types = JSON.parse(StaticContent.find_by(name: "wasteTypes").content)

    device = registration_to_check.notification_device
    return unless device.present?

    # Message to send
    title = "SmartVillageApp - Abfallkalender"
    body = "Am #{waste_pickup_time.pickup_date} wird #{waste_types[registration_to_check.notify_for_waste_type]["label"]} in #{registration_to_check.street} abgeholt"
    message_options = { title: title, body: body }
    messages = [message_options.merge(to: device.token)]

    # sending message
    client = Exponent::Push::Client.new
    client.send_messages(messages)
  end
end
