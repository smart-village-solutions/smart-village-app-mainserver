# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.mailjet[:default_from]
  layout "mailer"
end
