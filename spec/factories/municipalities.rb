# frozen_string_literal: true

FactoryBot.define do
  factory :municipality do
    slug { Faker::Internet.domain_word }
    title { Faker::Name.unique.name }
    settings { {} }
  end
end

# == Schema Information
#
# Table name: municipalities
#
#  id         :bigint           not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  settings   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
