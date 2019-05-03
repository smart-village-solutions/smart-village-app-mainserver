class DataProvider < ApplicationRecord
    belongs_to :provideable, polymorphic: true
    has_many :adresses, as: :adressable
    has_many :contacts, as: :contactable
end

# == Schema Information
#
# Table name: data_providers
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  logo             :string(255)
#  description      :string(255)
#  provideable_type :string(255)
#  provideable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
