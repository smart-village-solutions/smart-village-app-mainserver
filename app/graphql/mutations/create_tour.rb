# frozen_string_literal: true

module Mutations
  class CreateTour < BaseMutation
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
    argument :contact, Types::InputTypes::ContactInput, required: false, as: :contact_attributes,
                                            prepare: ->(contact, _ctx) { contact.to_h }
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
    argument :length_km, Integer, required: true
    argument :means_of_transportation, String, required: false
    argument :geometry_tour_data, [Types::InputTypes::GeoLocationInput], required: false,
                                                             as: :geometry_tour_data_attributes,
                                                             prepare: lambda { |geometry_tour_data, _ctx|
                                                                        geometry_tour_data.map(&:to_h)
                                                                      }
    argument :tags, [String], as: :tag_list, required: false
    argument :tour_stops, [Types::InputTypes::TourStopInput], required: false,
                                                  as: :tour_stops_attributes,
                                                  prepare: lambda { |tour_stops, _ctx|
                                                    tour_stops.map(&:to_h)
                                                  }

    field :tour, Types::QueryTypes::TourType, null: false

    type Types::QueryTypes::TourType

    def resolve(**params)
      data_provider = context[:current_user].try(:data_provider)

      # set data provider of each tour stop in params because it is required for tour stop creations
      if params[:tour_stops_attributes].present?
        params[:tour_stops_attributes].each do |tour_stop|
          tour_stop[:data_provider_id] = data_provider.try(:id)
        end
      end

      ResourceService.new(data_provider: data_provider).perform(Tour, params)
    end
  end
end
