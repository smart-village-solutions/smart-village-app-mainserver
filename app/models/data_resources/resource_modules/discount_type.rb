class DiscountType < ApplicationRecord
  belongs_to :discountable, polymorphic: true
end

# == Schema Information
#
# Table name: discount_types
#
#  id                     :bigint           not null, primary key
#  original_price         :decimal
#  discounted_price       :decimal
#  discount_percentage    :decimal
#  discount_amount        :decimal
#  content_blockable_id   :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
