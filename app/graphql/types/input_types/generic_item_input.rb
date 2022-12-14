# frozen_string_literal: true

module Types
  class InputTypes::GenericItemInput < BaseInputObject
    argument :force_create, Boolean, required: false
    argument :push_notification, Boolean, required: false
    argument :author, String, required: false
    argument :title, String, required: false
    argument :generic_type, String, required: false
    argument :external_id, String, required: false
    argument :publication_date, String, required: false
    argument :published_at, String, required: false
    argument :category_name, String, required: false
    argument :payload, GraphQL::Types::JSON, required: false
    argument :contacts, [Types::InputTypes::ContactInput],
             required: false, as: :contacts_attributes,
             prepare: ->(contacts, _ctx) { contacts.map(&:to_h) }
    argument :generic_items, [Types::InputTypes::GenericItemInput], required: false,
                                                                    as: :generic_items_attributes,
                                                                    prepare: lambda { |generic_items, _ctx|
                                                                      generic_items.map(&:to_h)
                                                                    }
    argument :companies, [Types::InputTypes::OperatingCompanyInput], required: false,
                                                                     as: :companies_attributes,
                                                                     prepare: lambda { |companies, _ctx|
                                                                       companies.map(&:to_h)
                                                                     }

    argument :categories, [Types::InputTypes::CategoryInput], required: false,
                                                              as: :category_names,
                                                              prepare: lambda { |category, _ctx|
                                                                category.map(&:to_h)
                                                              }
    argument :web_urls, [Types::InputTypes::WebUrlInput], required: false,
                                                          as: :web_urls_attributes,
                                                          prepare: ->(source_url, _ctx) { source_url.map(&:to_h) }
    argument :addresses, [Types::InputTypes::AddressInput], required: false,
                                                            as: :addresses_attributes,
                                                            prepare: lambda { |addresses, _ctx|
                                                              addresses.map(&:to_h)
                                                            }
    argument :content_blocks, [Types::InputTypes::ContentBlockInput], required: false,
                                                                      as: :content_blocks_attributes,
                                                                      prepare: lambda { |content_blocks, _ctx|
                                                                        content_blocks.map(&:to_h)
                                                                      }
    argument :opening_hours, [Types::InputTypes::OpeningHourInput], required: false,
                                                                    as: :opening_hours_attributes,
                                                                    prepare: lambda { |opening_hours, _ctx|
                                                                      opening_hours.map(&:to_h)
                                                                    }
    argument :price_informations, [Types::InputTypes::PriceInput], required: false,
                                                                   as: :price_informations_attributes,
                                                                   prepare: lambda { |price_informations, _ctx|
                                                                     price_informations.map(&:to_h)
                                                                   }
    argument :media_contents, [Types::InputTypes::MediaContentInput], required: false,
                                                                      as: :media_contents_attributes,
                                                                      prepare: lambda { |media_contents, _ctx|
                                                                        media_contents.map(&:to_h)
                                                                      }
    argument :locations, [Types::InputTypes::LocationInput], required: false,
                                                             as: :locations_attributes,
                                                             prepare: ->(location, _ctx) { location.map(&:to_h) }
    argument :dates, [Types::InputTypes::DateInput], required: false,
                                                     as: :dates_attributes,
                                                     prepare: ->(dates, _ctx) { dates.map(&:to_h) }
    argument :accessibility_informations, [Types::InputTypes::AccessibilityInformationInput],
             required: false, as: :accessibility_informations_attributes,
             prepare: lambda { |accessibility_informations, _ctx|
               accessibility_informations.map(&:to_h)
             }
  end
end
