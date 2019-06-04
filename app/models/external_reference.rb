class ExternalReference < ApplicationRecord
  belongs_to :external, polymorphic: true
  belongs_to :data_provider
end

# == Schema Information
#
# Table name: external_references
#
#  id               :bigint           not null, primary key
#  external_id      :integer
#  data_provider_id :integer
#  external_type    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
