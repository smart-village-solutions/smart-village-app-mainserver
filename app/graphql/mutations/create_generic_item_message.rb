# frozen_string_literal: false

module Mutations
  class CreateGenericItemMessage < BaseMutation
    argument :generic_item_id, ID, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :phone_number, String, required: false
    argument :message, String, required: true
    argument :terms_of_service, Boolean, required: true
    argument :visible, Boolean, required: false

    type Types::StatusType

    def resolve(
      generic_item_id:,
      name:,
      email:,
      phone_number: nil,
      message:,
      terms_of_service:,
      visible: false
    )
      if terms_of_service == false
        return error_status("Access not permitted: Please accept the terms of service")
      end

      generic_item = GenericItem.find_by(id: generic_item_id)

      return error_status("Access not permitted: GenericItem missing") if generic_item.blank?

      generic_item_message = GenericItem::Message.create(
        generic_item_id: generic_item_id,
        name: name,
        email: email,
        phone_number: phone_number,
        message: message,
        terms_of_service: terms_of_service
      )

      unless generic_item_message.valid?
        return error_status(
          "Access not permitted: GenericItem::Message invalid,
          #{generic_item_message.error_messages}"
        )
      end

      begin
        generic_item_message.save

        OpenStruct.new(
          id: generic_item_message.id,
          status: "Message successfully sent",
          status_code: 200
        )
      rescue StandardError => e
        error_status("Error with GenericItem::Message: #{e}", 500)
      end
    end

    private

      def error_status(description, status_code = 403)
        OpenStruct.new(id: nil, status: description, status_code: status_code)
      end
  end
end
