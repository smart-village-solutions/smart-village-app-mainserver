# frozen_string_literal: true

class NoticeboardMailerPreview < ActionMailer::Preview
  def notify_creator
    generic_item = OpenStruct.new(
      generic_type: GenericItem::GENERIC_TYPES[:noticeboard],
      title: "Test",
      published_at: Time.now
    )

    generic_item.contacts = [OpenStruct.new(first_name: "Tim Test", email: "tim.test@smart-village.app")]
    generic_item.categories = [OpenStruct.new(name: "Angebot")]
    generic_item.dates = [OpenStruct.new(date_start: Time.now, date_end: Time.now + 3.months)]
    generic_item.content_blocks = [OpenStruct.new(body: "Test", title: "Test")]
    generic_item.external_reference = OpenStruct.new(unique_id: "1234567890")

    StaticContent.find_or_create_by(name: "noticeboard-notify-creator", data_type: "json") do |s|
      s.content = "{\"app_name\":\"Test-App\",\"mail_footer\":[\"Zeile 1\", \"\", \"Zeile 2\"]}"
    end

    NoticeboardMailer.notify_creator(generic_item)
  end

  def new_message_for_entry
    generic_item = OpenStruct.new(
      generic_type: GenericItem::GENERIC_TYPES[:noticeboard],
      title: "Test",
      published_at: Time.now
    )

    generic_item.contacts = [OpenStruct.new(first_name: "Tim Test", email: "tim.test@smart-village.app")]
    generic_item.categories = [OpenStruct.new(name: "Angebot")]
    generic_item.dates = [OpenStruct.new(date_start: Time.now, date_end: Time.now + 3.months)]
    generic_item.content_blocks = [OpenStruct.new(body: "Test", title: "Test")]
    generic_item.external_reference = OpenStruct.new(unique_id: "1234567890")

    generic_item_message = OpenStruct.new(
      generic_item: generic_item,
      name: "Tim Sender Test",
      email: "tim.sender.test@smart-village.app",
      phone_number: nil,
      message: "Lorem ipsum dolor",
      terms_of_service: true
    )

    StaticContent.find_or_create_by(name: "noticeboard-notify-creator", data_type: "json") do |s|
      s.content = "{\"app_name\":\"Test-App\",\"mail_footer\":[\"Zeile 1\", \"\", \"Zeile 2\"]}"
    end

    NoticeboardMailer.new_message_for_entry(generic_item_message)
  end
end
