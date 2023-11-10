# frozen_string_literal: true

class WasteNotificationJob
  def self.perform(waste_registration_id, waste_pickup_time_id)
    waste_pickup_time = Waste::PickUpTime.find_by(id: waste_pickup_time_id)
    return if waste_pickup_time.blank?
    return if waste_pickup_time.pickup_date.blank?

    registration_to_check = Waste::DeviceRegistration.find_by(id: waste_registration_id)
    return if registration_to_check.blank?

    device = registration_to_check.notification_device
    return if device.blank?

    static_content = StaticContent.find_by(name: "wasteTypes")
    return if static_content.blank?

    waste_types = JSON.parse(static_content.content)

    # Message to send
    title = "Abfallkalender"
    parsed_date = waste_pickup_time.pickup_date.try(:strftime, "%d.%m.%Y")
    body = "#{registration_to_check.street}: Am #{parsed_date} wird #{waste_types[registration_to_check.notify_for_waste_type]["label"]} abgeholt."
    message_options = { title: title, body: body }

    PushNotification.delay.send_notification(device, message_options)
  end
end
