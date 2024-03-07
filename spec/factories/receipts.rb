# == Schema Information
#
# Table name: receipts
#
#  id         :bigint           not null, primary key
#  message_id :bigint           not null
#  member_id  :bigint           not null
#  read       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :receipt do
    message { nil }
    member { nil }
    read { false }
    default { "" }
  end
end
