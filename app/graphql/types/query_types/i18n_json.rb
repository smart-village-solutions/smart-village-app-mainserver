# frozen_string_literal: true

module Types
  class QueryTypes::I18nJSON < GraphQL::Types::JSON
    description <<-DESCRIPTION
      A specific JSON type representing I18n
      text data, for example:
      ```
      {
        de: \"deutscher Text\",
        en: \"englischer Text\"
      }
      ```
    DESCRIPTION
  end
end
