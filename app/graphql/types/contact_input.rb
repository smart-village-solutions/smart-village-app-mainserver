# frozen_string_literal: true

module Types
  class ContactInput < BaseInputObject
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :phone, String, required: true
    argument :fax, String, required: true
    argument :web_urls, [Types::WebUrlInput], required: true, as: :web_urls_attributes, prepare: ->(web_urls, ctx) { web_urls.map(&:to_h) }
    argument :email, String, required: true
  end
end
