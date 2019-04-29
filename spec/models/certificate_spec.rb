require 'rails_helper'

RSpec.describe Certificate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string(255)
#  point_of_interest_id :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
