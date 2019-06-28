# frozen_string_literal: true

module Types
  class MediaContentInput < BaseInputObject
    argument :caption_text, String, required: false
    argument :copyright, String, required: false
    argument :height, AnyPrimativeType, required: false
    argument :width, AnyPrimativeType, required: false
    argument :content_type, String, required: false
    argument :source_url, Types::WebUrlInput, required: false,
                                              as: :source_url_attributes,
                                              prepare: ->(source_url, _ctx) { source_url.to_h }
  end
end
