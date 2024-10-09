class DiscountType < ApplicationRecord
  belongs_to :discountable, polymorphic: true
end

# == Schema Information
#
# Table name: discount_types
#
#  id                  :bigint           not null, primary key
#  original_price      :decimal(10, 2)
#  discounted_price    :decimal(10, 2)
#  discount_percentage :decimal(5, )
#  discount_amount     :decimal(10, 2)
#  discountable_type   :string(255)
#  discountable_id     :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
