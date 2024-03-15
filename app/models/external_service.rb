# frozen_string_literal: true

class ExternalService < ApplicationRecord
  # include MunicipalityScope

  store :resource_config,
        accessors: %i[
          resource_event
          resource_poi
          resource_news_item
        ], coder: JSON

  store :auth_config,
        accessors: %i[
          auth_type
          auth_client_id
          auth_client_secret
          auth_scope
        ], coder: JSON

  belongs_to :municipality
  belongs_to :data_provider
end
