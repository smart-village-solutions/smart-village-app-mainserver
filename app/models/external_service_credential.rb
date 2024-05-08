# frozen_string_literal: true

class ExternalServiceCredential < ApplicationRecord
  store :additional_params, coder: JSON

  belongs_to :external_service, optional: true
  belongs_to :data_provider
end

# == Schema Information
#
# Table name: external_service_credentials
#
#  id                  :bigint           not null, primary key
#  client_key          :text(65535)
#  client_secret       :text(65535)
#  scopes              :string(255)
#  auth_type           :string(255)
#  external_id         :text(65535)
#  external_service_id :bigint           not null
#  data_provider_id    :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  additional_params   :text(65535)
#
