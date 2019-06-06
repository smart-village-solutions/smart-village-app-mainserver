FactoryBot.define do
  factory :external_reference do
    external_id { "MyString" }
    data_provider_id { 1 }
    external_id { 1 }
    external_type { "MyString" }
  end
end

# == Schema Information
#
# Table name: external_references
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  unique_id        :string(255)
#  data_provider_id :integer
#  external_id      :integer
#  external_type    :string(255)
#
