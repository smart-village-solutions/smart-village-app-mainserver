# frozen_string_literal: true
module Messaging
  class SendNotificationsService
    def self.notify_new_message(message_id)
      message = Messaging::Message.find_by(id: message_id)
      return unless message

      message.conversation.conversation_participants.each do |participant|
        notification_receiver = participant.member
        municipality_id = notification_receiver.municipality_id

        next if notification_receiver == message.sender

        send_push_notification(notification_receiver, municipality_id) if participant.push_notification_enabled?
        send_email_notification(notification_receiver.id, municipality_id) if participant.email_notification_enabled?
      end
    end

    def self.send_push_notification(participant, municipality_id)
      p "Sending push notification to #{participant.email}"
      message_options = {
        title: "New message",
        body: "You have a new unread message"
      }

      participant.notification_devices.each do |device|
        PushNotification.delay.send_notification(device, message_options, municipality_id)
      end
    end

    def self.send_email_notification(receiver_id, municipality_id)
      p "Sending email notification to #{receiver_id}"
      NotificationMailer.new_message_notification(receiver_id, municipality_id).deliver_later
    end
  end
end
