# frozen_string_literal: true

# Erinnere den Kunden daran, sein Profil regelmäßig zu aktualisieren
class BusinessAccountReminder
  OUTDATED_AFTER = 6.month

  class << self

    # accounts which
    # - are from type business_account
    # - have no flag in :business_account_outdated_notification_sent_at and therefore no notification received
    # - are not updated since given period of Time
    def accounts(outdated_after = OUTDATED_AFTER)
      User.where(business_account_outdated_notification_sent_at: [nil, ""])
        .where(data_providers: { data_type: 1 }).includes(:data_provider)
        .where("users.updated_at < ?", Time.zone.now - outdated_after) + User.where(
        "business_account_outdated_notification_sent_at < ?", 2.months.ago
      )
    end

    # Sende eine Benachrichtigung per E-Mail
    def send_notification
      accounts.each do |user|
        if user.business_account_outdated_notification_sent_at.present?
          NotificationMailer.delay.business_account_outdated_reminder(user)
        else
          NotificationMailer.delay.business_account_outdated(user)
        end
        user.update_column(:business_account_outdated_notification_sent_at, Time.zone.now)
      end
    end
  end
end
