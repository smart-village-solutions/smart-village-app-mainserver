# attribute quantity: Integer represents number of simultaneous redemptions
class Redemption < ApplicationRecord
  belongs_to :member
  belongs_to :redemable, polymorphic: true
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
