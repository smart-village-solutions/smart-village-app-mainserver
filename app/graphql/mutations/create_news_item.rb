# frozen_string_literal: true

module Mutations
  class CreateNewsItem < BaseMutation
    argument :external_id, Integer, required: false
    argument :title, String, required: false
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
    argument :data_provider, Types::DataProviderInput, required: false,
                                                       as: :data_provider_attributes,
                                                       prepare: lambda { |data_provider, _ctx|
                                                                  data_provider.to_h
                                                                }
    argument :content_blocks, [Types::ContentBlockInput], required: false,
                                                          as: :content_blocks_attributes,
                                                          prepare: lambda { |content_blocks, _ctx|
                                                                     content_blocks.map(&:to_h)
                                                                   }

    field :news_item, Types::NewsItemType, null: true

    type Types::NewsItemType

    def resolve(**params)
      NewsItem.create!(params)
    end
  end
end
