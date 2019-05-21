module Types
  class MediaContentInput < BaseInputObject
    argument :caption_text, String, required: false
    argument :copyright, String, required: false
    argument :height, Integer, required: false
    argument :width, Integer, required: false
    argument :content_type, String, required: false
    argument :source_url, Types::WebUrlInput, required: false, as: :source_url_attributes, prepare: ->(source_url, ctx) { source_url.to_h }
  end
end