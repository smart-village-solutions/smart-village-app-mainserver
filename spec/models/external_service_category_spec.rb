require 'rails_helper'

RSpec.describe ExternalServiceCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: external_service_categories
#
#  id                  :bigint           not null, primary key
#  external_id         :string(255)
#  external_service_id :bigint           not null
#  category_id         :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
