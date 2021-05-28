# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings.config[:mailjet][:default_from]
  layout "mailer"
end
