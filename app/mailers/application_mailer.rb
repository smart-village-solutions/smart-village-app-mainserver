# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailjet[:default_from]
  layout "mailer"
end
