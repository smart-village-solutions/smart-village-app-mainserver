# == Schema Information
#
# Table name: prices
#
#  id                 :bigint(8)        not null, primary key
#  name               :string(255)
#  price              :integer
#  group_price        :boolean
#  age_from           :integer
#  age_to             :integer
#  min_adult_count    :integer
#  max_adult_count    :integer
#  min_children_count :integer
#  max_children_count :integer
#  description        :string(255)
#  priceable_type     :string(255)
#  priceable_id       :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Price < ApplicationRecord
    belongs_to :priceable, polymorphic: true
end
