# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default template_path: "/mailers/notification"

  def notify_admin(notify_admin_content, municipality_id)
    @notify_admin_content = notify_admin_content

    mail(
      to: Municipality.find_by(id: municipality_id).settings[:mailer_notify_admin_to],
      subject: t("mailers.notification.notify_admin.subject")
    )
  end

  def survey_commented(comment, survey, municipality_id)
    creator_of_survey = survey.try(:data_provider).try(:user)

    return if creator_of_survey.blank?

    @survey = survey
    @comment = comment
    @cms_url = Municipality.find_by(id: municipality_id).settings[:cms_url]

    mail(
      to: creator_of_survey.email,
      subject: t("mailers.notification.survey_commented.subject")
    )
  end
end
