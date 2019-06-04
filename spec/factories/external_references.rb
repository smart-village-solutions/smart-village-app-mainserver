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
#  external_id      :integer
#  data_provider_id :integer
#  external_type    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
