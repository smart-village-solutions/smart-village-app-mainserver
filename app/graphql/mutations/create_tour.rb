# frozen_string_literal: true

module Mutations
  class CreateTour < BaseMutation
    argument :name, String, required: true
    argument :external_id, Integer, required: false
    argument :description, String, required: false
    argument :mobile_description, String, required: false
    argument :active, Boolean, required: false
    argument :category_name, String, required: false
    argument :addresses, [Types::AddressInput], required: false,
                                                as: :addresses_attributes,
                                                prepare: lambda { |addresses, _ctx|
                                                  addresses.map(&:to_h)
                                                }
    argument :contact, Types::ContactInput, required: false, as: :contact_attributes,
                                            prepare: ->(contact, _ctx) { contact.to_h }
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
    argument :length_km, Integer, required: true
    argument :means_of_transportation, String, required: false
    argument :geometry_tour_data, [Types::GeoLocationInput], required: false,
                                                             as: :geometry_tour_data_attributes,
                                                             prepare: lambda { |geometry_tour_data, _ctx|
                                                                        geometry_tour_data.map(&:to_h)
                                                                      }
    argument :tags, [String], as: :tag_list, required: false

    field :tour, Types::TourType, null: false

    type Types::TourType

    def resolve(**params)
      Tour.create!(params)
    end
  end
end
