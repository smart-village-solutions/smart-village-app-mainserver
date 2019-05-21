# frozen_string_literal: true

module Types
  class ContactInput < BaseInputObject
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :phone, String, required: false
    argument :fax, String, required: false
    argument :web_urls, [Types::WebUrlInput], required: false,
                                              as: :web_urls_attributes,
                                              prepare: ->(web_urls, _ctx) { web_urls.map(&:to_h) }
    argument :email, String, required: false
  end
end
