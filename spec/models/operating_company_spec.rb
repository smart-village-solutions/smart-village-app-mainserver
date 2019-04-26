# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint(8)        not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe OperatingCompany, type: :model do
  it { should belong_to(:companyable) }
  it { should have_many(:adresses) }
  it { should have_many(:contacts) }
end
