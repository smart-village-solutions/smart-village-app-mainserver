# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default template_path: "/mailers/notification"

  before_action :set_sva_community, only: [:business_account_outdated, :business_account_outdated_reminder]

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

  def business_account_outdated(user)
    mail(
      to: user.email,
      from: "noreply@smart-village.solutions",
      subject: "Überprüfung Ihrer Inhalte in der #{@sva_community_name} App"
    )
  end

  def business_account_outdated_reminder(user)
    mail(
      to: user.email,
      from: "noreply@smart-village.solutions",
      subject: "[Reminder] Bitte überprüfen Sie ihre Inhalte in der #{@sva_community_name} App"
    )
  end

  private

    def set_sva_community(sva_community=ENV["SVA_COMMUNITY"])
      @sva_community = sva_community
      name = sva_community[3..] if sva_community =~ /^[a-z]{2}-/
      @sva_community_name = name.split("-").map(&:capitalize).join(" ")
    end
end
