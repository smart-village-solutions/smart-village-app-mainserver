# frozen_string_literal: false

module Mutations
  class CreateEventRecord < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :parent_id, Integer, required: false
    argument :description, String, required: false
    argument :external_id, String, required: false
    argument :title, String, required: false
    argument :dates, [Types::InputTypes::DateInput], required: false,
                                         as: :dates_attributes,
                                         prepare: ->(dates, _ctx) { dates.map(&:to_h) }
    argument :repeat, Boolean, required: false
    argument :repeat_duration, Types::InputTypes::RepeatDurationInput, required: false,
                                                           as: :repeat_duration_attributes,
                                                           prepare: lambda { |repeat_duration, _ctx|
                                                                      repeat_duration.to_h
                                                                    }
    argument :category_name, String, required: false
    argument :categories, [Types::InputTypes::CategoryInput], required: false,
                                                  as: :category_names,
                                                  prepare: lambda { |category, _ctx|
                                                             category.map(&:to_h)
                                                           }
    argument :region_name, String, required: false
    argument :region, Types::InputTypes::RegionInput, required: false
    argument :addresses, [Types::InputTypes::AddressInput], required: false,
                                                as: :addresses_attributes,
                                                prepare: lambda { |addresses, _ctx|
                                                  addresses.map(&:to_h)
                                                }
    argument :location, Types::InputTypes::LocationInput, required: false,
                                              as: :location_attributes,
                                              prepare: ->(location, _ctx) { location.to_h }
    argument :contacts, [Types::InputTypes::ContactInput], required: false, as: :contacts_attributes,
                                               prepare: ->(contacts, _ctx) { contacts.map(&:to_h) }
    argument :urls, [Types::InputTypes::WebUrlInput], required: false, as: :urls_attributes,
                                          prepare: ->(urls, _ctx) { urls.map(&:to_h) }
    argument :media_contents, [Types::InputTypes::MediaContentInput], required: false,
                                                          as: :media_contents_attributes,
                                                          prepare: lambda { |media_contents, _ctx|
                                                            media_contents.map(&:to_h)
                                                          }
    argument :organizer, Types::InputTypes::OperatingCompanyInput, required: false,
                                                       as: :organizer_attributes,
                                                       prepare: lambda { |organizer, _ctx|
                                                                  organizer.to_h
                                                                }
    argument :price_informations, [Types::InputTypes::PriceInput], required: false,
                                                       as: :price_informations_attributes,
                                                       prepare: lambda { |price_informations, _ctx|
                                                                  price_informations.map(&:to_h)
                                                                }
    argument :accessibility_information,
             Types::InputTypes::AccessibilityInformationInput,
             required: false,
             as: :accessibility_information_attributes,
             prepare: lambda { |accessibility_information, _ctx|
                        accessibility_information.to_h
                      }
    argument :tags, [String], as: :tag_list, required: false
    argument :recurring, String, required: false
    argument :recurring_weekdays, [String], required: false
    argument :recurring_type, String, required: false
    argument :recurring_interval, String, required: false

    field :event, Types::QueryTypes::EventRecordType, null: true

    type Types::QueryTypes::EventRecordType

    def resolve(**params)
      ResourceService.new(data_provider: context[:current_user].try(:data_provider))
        .perform(EventRecord, params)
    end
  end
end
