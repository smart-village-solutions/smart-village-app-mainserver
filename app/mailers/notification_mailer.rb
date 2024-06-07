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
      subject: t("mailers.notification.notify_admin.subject")
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

  def new_message_notification(receiver_id, municipality_id)
    municipality = Municipality.find_by(id: municipality_id)
    set_delivery_options(municipality)

    member = Member.find_by(id: receiver_id)

    return unless member&.email.present?

    mail(
      to: member.email,
      from: municipality.settings[:mailjet_default_from],
      subject: t("mailers.notification.new_message.subject")
    )
  end

  def email_changed(member_id, first_name, new_email, municipality_id)
    municipality = Municipality.find_by(id: municipality_id)
    set_delivery_options(municipality)
    set_static_content_values

    @member = Member.find_by(id: member_id)
    @first_name = first_name
    @new_email = new_email

    mail(
      to: @member.email,
      from: municipality.settings[:mailjet_default_from],
      subject: t("mailers.notification.email_changed.subject")
    )
  end

  private

    def set_static_content_values
      static_content = StaticContent.find_by(name: "mailer-config").try(:content)

      begin
        static_content = JSON.parse(static_content)
      rescue StandardError
        return
      end

      @app_name = static_content["app_name"]
      @mail_footer = static_content["mail_footer"].join("\n")
    end
end
