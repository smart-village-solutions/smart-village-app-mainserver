# frozen_string_literal: true

FactoryBot.define do
  factory :quota do
    max_quantity { 100 }
    frequency { "once" }
    max_per_person { 2 }
  end
end

# == Schema Information
#
# Table name: quotas
#
#  id             :bigint           not null, primary key
#  max_quantity   :integer
#  frequency      :integer
#  max_per_person :integer
#  quotaable_type :string(255)
#  quotaable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  visibility     :integer          default("private_visibility")
#
