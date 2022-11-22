# frozen_string_literal: true

class NoticeboardMailer < ApplicationMailer
  default template_path: "/mailers/noticeboard"

  def notify_creator(generic_item)
    begin
      static_content = StaticContent.find_by(name: "noticeboard-notify-creator").try(:content)
      static_content = JSON.parse(static_content)
    rescue StandardError
      return
    end

    @app_name = static_content["app_name"]
    @mail_footer = static_content["mail_footer"].join("\n")
    @name = generic_item.contacts.first.try(:first_name)
    @email = generic_item.contacts.first.try(:email)
    @category = generic_item.category_name
    @date_end = generic_item.dates.first.try(:date_end).try(:strftime, "%d.%m.%Y")
    @destroy_url = confirm_record_action_url(
      confirm_action: "destroy",
      token: generic_item.external_reference.unique_id
    )

    return unless is_valid?

    mail(
      from: "#{@app_name} <#{default_params[:from]}>",
      to: "#{@name} <#{@email}>",
      subject: "Ihr Eintrag (#{@category}) für die #{@app_name} wurde freigeschaltet"
    )
  end

  private

    def is_valid?
      @app_name.present? &&
        @mail_footer.present? &&
        @name.present? &&
        @email.present? &&
        @category.present? &&
        @date_end.present? &&
        @destroy_url.present?
    end
end
