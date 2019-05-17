module Types
  class WebUrlInput < BaseInputObject
    argument :url, String, required: false
    argument :description, String, required: false
  end
end