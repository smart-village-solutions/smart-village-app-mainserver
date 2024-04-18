# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailjet[:default_from]
  layout "mailer"

  around_action :with_custom_smtp_settings

  # Setzt die Mailer Einstellungen für die Zustellung der E-Mail
  # abhängig von den Einstellungen der Kommune
  #
  # @param [Municipality] municipality
  def set_delivery_options(municipality)
    municipality_settings = municipality.settings
    MunicipalityService.municipality_id = municipality.id


    case municipality_settings[:mailer_type]
    when "mailjet"
      ActionMailer::Base.delivery_method = :mailjet
      Mailjet.config.api_key = municipality_settings[:mailjet_api_key]
      Mailjet.config.secret_key = municipality_settings[:mailjet_api_secret]
      Mailjet.config.default_from = municipality_settings[:mailjet_default_from]
    when "smtp"
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings[:address] = municipality_settings[:smtp_address]
      ActionMailer::Base.smtp_settings[:port] = municipality_settings[:smtp_port].presence || 465
      ActionMailer::Base.smtp_settings[:domain] = municipality_settings[:smtp_domain]
      ActionMailer::Base.smtp_settings[:user_name] = municipality_settings[:smtp_user_name]
      ActionMailer::Base.smtp_settings[:password] = municipality_settings[:smtp_password]
      ActionMailer::Base.smtp_settings[:authentication] = municipality_settings[:smtp_authentication].presence || "plain"
      ActionMailer::Base.smtp_settings[:ssl] = municipality_settings[:smtp_ssl] == "true" ? true : nil
      ActionMailer::Base.smtp_settings[:enable_starttls_auto] = municipality_settings[:smtp_enable_starttls_auto] == "true"
    end
  end

  private

    # Absicherung der Mailer Settings, damit die Werte nach dem Versand wieder zurückgesetzt werden
    # und nicht global für alle Mailer gesetzt bleiben
    def with_custom_smtp_settings
      original_delivery_method = ActionMailer::Base.delivery_method
      original_smtp_settings = ActionMailer::Base.smtp_settings.dup
      original_mailjet_settings = { api_key: Mailjet.config.api_key, secret_key: Mailjet.config.secret_key, default_from: Mailjet.config.default_from }
      begin
        yield
      ensure
        ActionMailer::Base.delivery_method = original_delivery_method
        ActionMailer::Base.smtp_settings = original_smtp_settings
        Mailjet.config.api_key = original_mailjet_settings[:api_key]
        Mailjet.config.secret_key = original_mailjet_settings[:secret_key]
        Mailjet.config.default_from = original_mailjet_settings[:default_from]
      end
    end
end
