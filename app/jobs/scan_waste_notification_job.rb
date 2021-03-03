class ScanWasteNotificationJob < CronJob
  # set the (default) cron expression
  self.cron_expression = '5 0 * * *'

  # will enqueue the mailing delivery job
  def perform
    WasteNotification.new().send_notifications
  end
end
