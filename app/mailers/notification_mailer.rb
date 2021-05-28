# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default template_path: "/mailers/notification"

  def notify_admin(notify_admin_content)
    @notify_admin_content = notify_admin_content

    mail(
      to: Settings.config[:mailer][:notify_admin][:to],
      subject: t("mailers.notification.notify_admin.subject")
    )
  end
end
