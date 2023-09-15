# frozen_string_literal: true

module Mutations
  class CreatePointOfInterest < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :name, String, required: true
    argument :external_id, String, required: false
    argument :description, String, required: false
    argument :mobile_description, String, required: false
    argument :active, Boolean, required: false
    argument :category_name, String, required: false
    argument :payload, GraphQL::Types::JSON, required: false
    argument :categories, [Types::InputTypes::CategoryInput], required: false,
                                                  as: :category_names,
                                                  prepare: lambda { |category, _ctx|
                                                             category.map(&:to_h)
                                                           }
    argument :addresses, [Types::InputTypes::AddressInput], required: false,
                                                as: :addresses_attributes,
                                                prepare: lambda { |addresses, _ctx|
                                                  addresses.map(&:to_h)
                                                }
    argument :contact, Types::InputTypes::ContactInput,
             required: false, as: :contact_attributes,
             prepare: ->(contact, _ctx) { contact.to_h }
    argument :price_informations, [Types::InputTypes::PriceInput],
             required: false, as: :price_informations_attributes,
             prepare: ->(price_informations, _ctx) { price_informations.map(&:to_h) }
    argument :opening_hours, [Types::InputTypes::OpeningHourInput], required: false,
                                                        as: :opening_hours_attributes,
                                                        prepare: lambda { |opening_hours, _ctx|
                                                                   opening_hours.map(&:to_h)
                                                                 }
    argument :operating_company, Types::InputTypes::OperatingCompanyInput, required: false,
                                                               as: :operating_company_attributes,
                                                               prepare:
                                                               lambda { |operating_company, _ctx|
                                                                 operating_company.to_h
                                                               }
    argument :web_urls, [Types::InputTypes::WebUrlInput], required: false, as: :web_urls_attributes,
                                              prepare: ->(web_urls, _ctx) { web_urls.map(&:to_h) }
    argument :media_contents, [Types::InputTypes::MediaContentInput], required: false,
                                                          as: :media_contents_attributes,
                                                          prepare: lambda { |media_contents, _ctx|
                                                            media_contents.map(&:to_h)
                                                          }
    argument :location, Types::InputTypes::LocationInput, required: false,
                                              as: :location_attributes,
                                              prepare: ->(location, _ctx) { location.to_h }
    argument :certificates, [Types::InputTypes::CertificateInput], required: false,
                                                       as: :certificates_attributes,
                                                       prepare: lambda { |certificates, _ctx|
                                                                  certificates.map(&:to_h)
                                                                }
    argument :accessibility_information,
             Types::InputTypes::AccessibilityInformationInput,
             required: false,
             as: :accessibility_information_attributes,
             prepare: lambda { |accessibility_information, _ctx|
                        accessibility_information.to_h
                      }
    argument :tags, [String], as: :tag_list, required: false
    argument :lunches,
             [Types::InputTypes::LunchInput],
             required: false,
             as: :lunches_attributes,
             prepare: ->(lunches, _ctx) { lunches.map(&:to_h) }

    field :point_of_interest, Types::QueryTypes::PointOfInterestType, null: false

    type Types::QueryTypes::PointOfInterestType

    def resolve(**params)
      ResourceService.new(data_provider: context[:current_user].try(:data_provider))
        .perform(PointOfInterest, params)
    end
  end
end
