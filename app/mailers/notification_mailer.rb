# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default template_path: "/mailers/notification"

  def notify_admin(notify_admin_content, municipality_id)
    municipality = Municipality.find_by(id: municipality_id)
    set_delivery_options(municipality)

    @notify_admin_content = notify_admin_content

    mail(
      to: municipality.settings[:mailer_notify_admin_to],
      from: municipality.settings[:mailjet_default_from],
      subject: t("mailers.notification.notify_admin.subject"),
      delivery_method_options: delivery_options
    )
  end

  def survey_commented(comment, survey, municipality_id)
    municipality = Municipality.find_by(id: municipality_id)
    set_delivery_options(municipality)

    creator_of_survey = survey.try(:data_provider).try(:user)

    return if creator_of_survey.blank?

    @survey = survey
    @comment = comment
    @cms_url = municipality.settings[:cms_url]

    mail(
      to: creator_of_survey.email,
      from: municipality.settings[:mailjet_default_from],
      subject: t("mailers.notification.survey_commented.subject")
    )
  end

  def set_delivery_options(municipality)
    Mailjet.config.api_key = municipality.settings[:mailjet_api_key]
    Mailjet.config.secret_key = municipality.settings[:mailjet_api_secret]
    Mailjet.config.default_from = municipality.settings[:mailjet_default_from]
  end
end
