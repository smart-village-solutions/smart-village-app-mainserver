# frozen_string_literal: true

module Mutations
  class CreatePointOfInterest < BaseMutation
    argument :force_create, Boolean, required: false
    argument :name, String, required: true
    argument :description, String, required: false
    argument :mobile_description, String, required: false
    argument :active, Boolean, required: false
    argument :category_name, String, required: false
    argument :addresses, [Types::AddressInput], required: false,
                                                as: :addresses_attributes,
                                                prepare: lambda { |addresses, _ctx|
                                                  addresses.map(&:to_h)
                                                }

    argument :contact, Types::ContactInput,
             required: false, as: :contact_attributes,
             prepare: ->(contact, _ctx) { contact.to_h }

    argument :price_informations, [Types::PriceInput],
             required: false, as: :price_informations_attributes,
             prepare: ->(price_informations, _ctx) { price_informations.map(&:to_h) }
    argument :opening_hours, [Types::OpeningHourInput], required: false,
                                                        as: :opening_hours_attributes,
                                                        prepare: lambda { |opening_hours, _ctx|
                                                                   opening_hours.map(&:to_h)
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

    argument :tags, [String], as: :tag_list, required: false

    field :point_of_interest, Types::PointOfInterestType, null: false

    type Types::PointOfInterestType

    def resolve(**params)
      record = ResourceService.new(data_provider: context[:current_user].try(:data_provider))
                 .create(PointOfInterest, params)
      if record.valid?
        record
      else
        GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
      end
    end
  end
end
