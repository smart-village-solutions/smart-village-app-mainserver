require "rails_helper"

RSpec.describe Price, type: :model do
  it { should belong_to(:priceable) }
end

# == Schema Information
#
# Table name: prices
#
#  id                 :bigint           not null, primary key
#  name               :string(255)
#  amount             :float(24)
#  group_price        :boolean
#  age_from           :integer
#  age_to             :integer
#  min_adult_count    :integer
#  max_adult_count    :integer
#  min_children_count :integer
#  max_children_count :integer
#  description        :text(65535)
#  category           :string(255)
#  priceable_type     :string(255)
#  priceable_id       :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
