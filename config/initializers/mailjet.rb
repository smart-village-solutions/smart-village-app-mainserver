# frozen_string_literal: true
if Settings.mailjet.present?
  Mailjet.configure do |config|
    config.api_key = Settings.mailjet[:api_key]
    config.secret_key = Settings.mailjet[:secret_key]
    config.default_from = Settings.mailjet[:default_from]
  end
end
