# frozen_string_literal: true

module Mutations
  class CreateNewsItem < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :push_notification, Boolean, required: false
    argument :author, String, required: false
    argument :title, String, required: false
    argument :external_id, String, required: false
    argument :full_version, Boolean, required: false
    argument :characters_to_be_shown, Integer, required: false
    argument :news_type, String, required: false
    argument :publication_date, String, required: false
    argument :published_at, String, required: false
    argument :show_publish_date, Boolean, required: false
    argument :category_name, String, required: false
    argument :payload, GraphQL::Types::JSON, required: false
    argument :categories, [Types::InputTypes::CategoryInput], required: false,
                                                  as: :category_names,
                                                  prepare: lambda { |category, _ctx|
                                                             category.map(&:to_h)
                                                           }
    argument :source_url, Types::InputTypes::WebUrlInput, required: false,
                                              as: :source_url_attributes,
                                              prepare: ->(source_url, _ctx) { source_url.to_h }
    argument :address, Types::InputTypes::AddressInput, required: false,
                                            as: :address_attributes,
                                            prepare: lambda { |address, _ctx|
                                                       address.to_h
                                                     }
    argument :content_blocks, [Types::InputTypes::ContentBlockInput], required: false,
                                                          as: :content_blocks_attributes,
                                                          prepare: lambda { |content_blocks, _ctx|
                                                                     content_blocks.map(&:to_h)
                                                                   }

    field :news_item, Types::QueryTypes::NewsItemType, null: true

    type Types::QueryTypes::NewsItemType

    def resolve(**params)
      ResourceService.new(data_provider: context[:current_user].try(:data_provider))
        .perform(NewsItem, params)
    end
  end
end
