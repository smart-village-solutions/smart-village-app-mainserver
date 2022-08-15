# frozen_string_literal: true

class ExternalReference < ApplicationRecord
  belongs_to :external, polymorphic: true, optional: true
  belongs_to :data_provider
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
