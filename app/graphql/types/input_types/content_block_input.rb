# frozen_string_literal: true

module Types
  class InputTypes::ContentBlockInput < BaseInputObject
    argument :title, String, required: false
    argument :intro, String, required: false
    argument :body, String, required: false
    argument :media_contents, [Types::InputTypes::MediaContentInput], required: false,
                                                          as: :media_contents_attributes,
                                                          prepare: lambda { |media_contents, _ctx|
                                                            media_contents.map(&:to_h)
                                                          }
  end
end
