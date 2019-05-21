# frozen_string_literal: true

module Mutations
  class CreatePointOfInterest < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :mobile_description, String, required: false
    argument :active, Boolean, required: false
    argument :category_id, Integer, required: false
    argument :addresses, [Types::AddressInput], required: false,
                                                as: :addresses_attributes,
                                                prepare: lambda { |addresses, _ctx|
                                                  addresses.map(&:to_h)
                                                }
    argument :contact, Types::ContactInput, required: false, as: :contact_attributes,
                                            prepare: ->(contact, _ctx) { contact.to_h }
    argument :prices, [Types::PriceInput], required: false, as: :prices_attributes,
                                           prepare: ->(prices, _ctx) { prices.map(&:to_h) }
    argument :opening_hours, [Types::OpeningHourInput], required: false,
                                                        as: :opening_hours_attributes,
                                                        prepare: lambda { |opening_hours, _ctx|
                                                                   opening_hours.map(&:to_h)
                                                                 }
    argument :data_provider, Types::DataProviderInput, required: false,
                                                       as: :data_provider_attributes,
                                                       prepare: lambda { |data_provider, _ctx|
                                                                  data_provider.to_h
                                                                }
    argument :operating_company, Types::OperatingCompanyInput, required: false,
                                                               as: :operating_company_attributes,
                                                               prepare:
                                                               lambda { |operating_company, _ctx|
                                                                 operating_company.to_h
                                                               }
    argument :web_urls, [Types::WebUrlInput], required: false, as: :web_urls_attributes,
                                              prepare: ->(web_urls, _ctx) { web_urls.map(&:to_h) }
    argument :media_contents, [Types::MediaContentInput], required: false,
                                                          as: :media_contents_attributes,
                                                          prepare: lambda { |media_contents, _ctx|
                                                            media_contents.map(&:to_h)
                                                          }
    argument :location, Types::LocationInput, required: false,
                                              as: :location_attributes,
                                              prepare: ->(location, _ctx) { location.to_h }
    argument :certificates, [Types::CertificateInput], required: false,
                                                       as: :certificates_attributes,
                                                       prepare: lambda { |certificates, _ctx|
                                                                  certificates.map(&:to_h)
                                                                }
    argument :accessibility_information,
             Types::AccessibilityInformationInput,
             required: false,
             as: :accessibility_information_attributes,
             prepare: lambda { |accessibility_information, _ctx|
                        accessibility_information.to_h
                      }
    argument :tags, String, as: :tag_list, required: false

    field :point_of_interest, Types::PointOfInterestType, null: false

    type Types::PointOfInterestType

    def resolve(**params)
      PointOfInterest.create!(params)
    end
  end
end
