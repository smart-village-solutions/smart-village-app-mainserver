# frozen_string_literal: true

FactoryBot.define do
  factory :tour do
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :string(255)
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :text(65535)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#  visible                 :boolean          default(TRUE)
#  payload                 :text(65535)
#
