# frozen_string_literal: false

module Mutations
  class CreateOrUpdateStaticContent < BaseMutation
    argument :force_create, Boolean, required: false
    argument :id, ID, required: false
    argument :name, String, required: false
    argument :content, String, required: false
    argument :data_type, String, required: true
    argument :version, String, required: false

    field :static_content, Types::QueryTypes::PublicHtmlFileType, null: true

    type Types::QueryTypes::PublicHtmlFileType

    def resolve(**params)
      I18n.with_locale(:de) do
        params = params.merge(name: params.fetch(:name).parameterize)
      end

      create_or_update(params)
    end

    private

      def create_or_update(params)
        static_content_id = params.delete(:id)

        if static_content_id.present?
          static_content = StaticContent.filtered_for_current_user(context[:current_user])
                             .find_by(id: static_content_id)
          static_content&.update(params)
        else
          static_content = StaticContent.create(params)
        end

        resource_or_error_message(static_content)
      end

      def resource_or_error_message(record)
        return {} if record.blank?

        if record.valid?
          record
        else
          GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
        end
      end
  end
end
