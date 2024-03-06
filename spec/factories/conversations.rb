# == Schema Information
#
# Table name: conversations
#
#  id                    :bigint           not null, primary key
#  conversationable_type :string(255)      not null
#  conversationable_id   :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :conversation do
    conversationable { nil }
  end
end
