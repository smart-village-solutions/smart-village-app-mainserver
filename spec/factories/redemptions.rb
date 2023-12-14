FactoryBot.define do
  factory :redemption do
    member_id { 1 }
    quantity { 1 }
    redemable { nil }
  end
end

# == Schema Information
#
# Table name: redemptions
#
#  id             :bigint           not null, primary key
#  member_id      :integer
#  redemable_type :string(255)
#  redemable_id   :bigint
#  quantity       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
