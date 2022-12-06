# frozen_string_literal: true

class NoticeboardMailer < ApplicationMailer
  default template_path: "/mailers/noticeboard"

  before_action :set_static_content_values

  def notify_creator(generic_item)
    @name = generic_item.contacts.first.try(:first_name)
    @email = generic_item.contacts.first.try(:email)
    @category = generic_item.categories.first.try(:name)
    @date_end = generic_item.dates.first.try(:date_end).try(:strftime, "%d.%m.%Y")
    @destroy_url = confirm_record_action_url(
      confirm_action: "destroy",
      token: generic_item.external_reference.unique_id
    )

    return unless valid_for_notify_creator?

    mail(
      from: "#{@app_name} <#{default_params[:from]}>",
      to: "#{@name} <#{@email}>",
      subject: "Ihr Eintrag (#{@category}) für die #{@app_name} wurde freigeschaltet"
    )
  end

  def new_message_for_entry(generic_item_message)
    generic_item = generic_item_message.generic_item

    @name = generic_item.contacts.first.try(:first_name)
    @email = generic_item.contacts.first.try(:email)
    @title = generic_item.title
    @category = generic_item.categories.first.try(:name)
    @date_end = generic_item.dates.first.try(:date_end).try(:strftime, "%d.%m.%Y")
    @destroy_url = confirm_record_action_url(
      confirm_action: "destroy",
      token: generic_item.external_reference.unique_id
    )
    @message = generic_item_message.message
    @sender_name = generic_item_message.name
    @sender_email = generic_item_message.email
    @sender_phone_number = generic_item_message.phone_number

    return unless valid_for_new_message_for_entry?

    mail(
      from: "#{@app_name} <#{default_params[:from]}>",
      reply_to: "#{@sender_name} <#{@sender_email}>",
      to: "#{@name} <#{@email}>",
      subject: "Sie haben eine Nachricht zu Ihrem Eintrag (#{@category}) in der #{@app_name} erhalten"
    )
  end

  private

    def set_static_content_values
      static_content = StaticContent.find_by(name: "noticeboard-notify-creator").try(:content)

      begin
        static_content = JSON.parse(static_content)
      rescue StandardError
        return
      end

      @app_name = static_content["app_name"]
      @mail_footer = static_content["mail_footer"].join("\n")
    end

    def valid_for_notify_creator?
      @app_name.present? &&
        @mail_footer.present? &&
        @name.present? &&
        @email.present? &&
        @category.present? &&
        @date_end.present? &&
        @destroy_url.present?
    end

    def valid_for_new_message_for_entry?
      valid_for_notify_creator? &&
        @sender_name.present? &&
        @sender_email.present? &&
        @message.present?
    end
end
