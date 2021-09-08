# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default template_path: "/mailers/notification"

  def notify_admin(notify_admin_content)
    @notify_admin_content = notify_admin_content

    mail(
      to: Rails.application.credentials.mailer[:notify_admin][:to],
      subject: t("mailers.notification.notify_admin.subject")
    )
  end

  def survey_commented(comment, survey)
    creator_of_survey = survey.try(:data_provider).try(:user)

    return if creator_of_survey.blank?

    @survey = survey
    @comment = comment
    @cms_url = Rails.application.credentials.cms[:url]

    mail(
      to: creator_of_survey.email,
      subject: t("mailers.notification.survey_commented.subject")
    )
  end
end
