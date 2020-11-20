# frozen_string_literal: true

class PushNotification
  attr_accessor :client, :message_options

  def initialize(message_options = {})
    @client = Exponent::Push::Client.new
    @message_options = message_options
  end

  def send_notifications
    Notification::Device.all.each do |device|
      messages = [message_options.merge(to: device.token)]
      @client.send_messages(messages)
    end
  end
end
