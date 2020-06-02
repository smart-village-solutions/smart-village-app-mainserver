# frozen_string_literal: true

class NotificationMailerPreview < ActionMailer::Preview
  def notify_admin
    app_user_content = AppUserContent.first_or_create

    NotificationMailer.notify_admin(app_user_content)
  end
end
