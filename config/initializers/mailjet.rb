# frozen_string_literal: true
if Settings.config[:mailjet].present?
  Mailjet.configure do |config|
    config.api_key = Settings.config[:mailjet][:api_key]
    config.secret_key = Settings.config[:mailjet][:secret_key]
    config.default_from = Settings.config[:mailjet][:default_from]
  end
end
