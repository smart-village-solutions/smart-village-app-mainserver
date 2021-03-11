# frozen_string_literal: true

module Types
  class QueryTypes::SettingType < Types::BaseObject
    field :display_only_summary, String, null: true
    field :always_recreate_on_import, String, null: true
    field :only_summary_link_text, String, null: true
  end
end
