# frozen_string_literal: true

module Mutations
  class CreateAppUserContent < BaseMutation
    argument :data_source, String, required: false
    argument :data_type, String, required: false
    argument :content, String, required: false

    type Types::QueryTypes::AppUserContentType

    def resolve(**params)
      return spam_message if spam?

      app_user_content = AppUserContent.create(params)
      resource_or_error_message(app_user_content)
    end

    private

      def resource_or_error_message(record)
        if record.valid?
          record
        else
          GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
        end
      end

      def spam_message
        GraphQL::ExecutionError.new("Spam input")
      end

      # TODO: implement spam filter logic
      def spam?
        false
      end
  end
end
