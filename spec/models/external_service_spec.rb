# == Schema Information
#
# Table name: external_services
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  base_uri        :string(255)
#  resource_config :text(65535)
#  municipality_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe ExternalService, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
