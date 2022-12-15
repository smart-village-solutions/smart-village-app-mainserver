# frozen_string_literal: true

class DefectReportMailer < ApplicationMailer
  default template_path: "/mailers/defect_report"

  before_action :set_static_content_values

  def notify_for_category(generic_item)
    @title = generic_item.content_blocks.first.try(:title)
    @body = generic_item.content_blocks.first.try(:body)
    @category = generic_item.categories.first.try(:name)
    @category_email = generic_item.categories.first.try(:contact).try(:email)

    return unless valid_for_notify_for_category?

    @image_url = generic_item.media_contents.try(:first).try(:source_url).try(:url)

    @address = generic_item.addresses.try(:first)

    if @address.present?
      street = @address.street
      zip = @address.zip
      city = @address.city
      @location = "#{street}, #{zip} #{city}" if street && zip && city

      lat = @address.try(:geo_location).try(:latitude)
      lon = @address.try(:geo_location).try(:longitude)
      @map_link = "https://www.openstreetmap.org/?mlat=#{lat}&mlon=#{lon}" if lat && lon
    end

    creator = generic_item.contacts.try(:first)

    if creator.present?
      @name = creator.first_name
      @email = creator.email
      @phone = creator.phone
    end

    mail(
      from: "#{@app_name} <#{default_params[:from]}>",
      to: @category_email,
      subject: "[Mängelmelder] Neuer Eintrag in der Kategorie #{@category}"
    )
  end

  private

    def set_static_content_values
      static_content = StaticContent.find_by(name: "defectreport-notify-for-category").try(:content)

      begin
        static_content = JSON.parse(static_content)
      rescue StandardError
        return
      end

      @app_name = static_content["app_name"]
      @mail_footer = static_content["mail_footer"].join("\n")
    end

    def valid_for_notify_for_category?
      @app_name.present? &&
        @mail_footer.present? &&
        @title.present? &&
        @body.present? &&
        @category.present? &&
        @category_email.present?
    end
end
