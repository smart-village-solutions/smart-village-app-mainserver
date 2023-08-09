# frozen_string_literal: true

class DefectReportMailerPreview < ActionMailer::Preview
  def notify_for_category
    generic_item = OpenStruct.new(
      generic_type: GenericItem::GENERIC_TYPES[:defect_report],
      title: "Test"
    )

    generic_item.categories = [OpenStruct.new(name: "Abfall/Müll", contact: OpenStruct.new(email: "tom.tast@smart-village.app"))]
    generic_item.content_blocks = [OpenStruct.new(body: "Test mit mehr Worten", title: "Test")]
    generic_item.external_reference = OpenStruct.new(unique_id: "1234567890")

    StaticContent.find_or_create_by(name: "defectreport-notify-for-category", data_type: "json" ) do |s|
       s.content = "{\"app_name\":\"Test-App\",\"mail_footer\":[\"Zeile 1\", \"\", \"Zeile 2\"]}" 
    end

    DefectReportMailer.notify_for_category(generic_item)
  end

  def notify_for_category_with_additional_data
    generic_item = OpenStruct.new(
      generic_type: GenericItem::GENERIC_TYPES[:defect_report],
      title: "Test"
    )

    generic_item.contacts = [OpenStruct.new(first_name: "Tim Test", email: "tim.test@smart-village.app", phone: "0123456789")]
    generic_item.categories = [OpenStruct.new(name: "Abfall/Müll", contact: OpenStruct.new(email: "tom.tast@smart-village.app"))]
    generic_item.content_blocks = [OpenStruct.new(body: "Test mit mehr Worten", title: "Test")]
    generic_item.media_contents = [OpenStruct.new(source_url: OpenStruct.new(url: "https://fileserver.smart-village.app/herzberg-elster/ehrenamt/service-kalender.png"), content_type: "image")]
    generic_item.addresses = [OpenStruct.new(street: "Straße", zip: "03443", city: "Stadt", geo_location: OpenStruct.new(latitude: 50.1212, longitude: 13.3434))]
    generic_item.external_reference = OpenStruct.new(unique_id: "1234567890")

    StaticContent.find_or_create_by(name: "defectreport-notify-for-category", data_type: "json") do |s|
        s.content = "{\"app_name\":\"Test-App\",\"mail_footer\":[\"Zeile 1\", \"\", \"Zeile 2\"]}"
    end

    DefectReportMailer.notify_for_category(generic_item)
  end
end
