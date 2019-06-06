# frozen_string_literal: true

module Mutations
  class CreateNewsItem < BaseMutation
    argument :author, String, required: false
    argument :full_version, Boolean, required: false
    argument :characters_to_be_shown, Integer, required: false
    argument :news_type, String, required: false
    argument :publication_date, String, required: false
    argument :published_at, String, required: false
    argument :source_url, Types::WebUrlInput, required: false,
                                              as: :source_url_attributes,
                                              prepare: ->(source_url, _ctx) { source_url.to_h }
    argument :address, Types::AddressInput, required: false,
                                            as: :address_attributes,
                                            prepare: lambda { |address, _ctx|
                                                       address.to_h
                                                     }
    argument :content_blocks, [Types::ContentBlockInput], required: false,
                                                          as: :content_blocks_attributes,
                                                          prepare: lambda { |content_blocks, _ctx|
                                                                     content_blocks.map(&:to_h)
                                                                   }

    field :news_item, Types::NewsItemType, null: true

    type Types::NewsItemType

    def resolve(**params)
      ResourceService.new(data_provider: context[:current_user].try(:data_provider))
        .create(NewsItem, params)
    end
  end
end
