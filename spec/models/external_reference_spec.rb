# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalReference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: external_references
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  unique_id        :text(65535)
#  data_provider_id :integer
#  external_id      :integer
#  external_type    :string(255)
#
