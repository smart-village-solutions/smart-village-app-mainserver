# == Schema Information
#
# Table name: messaging_receipts
#
#  id         :bigint           not null, primary key
#  message_id :bigint           not null
#  member_id  :bigint           not null
#  read       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :messaging_receipt, class: "Messaging::Receipt" do
    association :message, factory: :messaging_message
    member
    read { false }
  end
end
