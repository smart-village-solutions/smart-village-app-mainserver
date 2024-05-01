# frozen_string_literal: true

module Types
  class InputTypes::AnnouncementOrganizerInput < BaseInputObject
    argument :organizer_type, String,
             description: "Organizer type should is required to be present to create announcement",
             required: true
    argument :organizer_id, ID,
             description: "Organizer ID should is required to be present to create announcement",
             required: true
  end
end
