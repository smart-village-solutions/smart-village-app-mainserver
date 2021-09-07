# frozen_string_literal: true

class NotificationMailerPreview < ActionMailer::Preview
  def notify_admin
    app_user_content = AppUserContent.first_or_create(
      data_type: "json",
      data_source: "form",
      content: {
        name: "Lorem Ipsum",
        email: "lorem@ipsum.dolor",
        phone: "00001212121",
        message: "Test \n Dolor dolore laborum cillum quis esse enim id.",
        consent: true
      }.to_json
    )

    NotificationMailer.notify_admin(app_user_content)
  end
end
