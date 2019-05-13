# frozen_string_literal: true

require "rails_helper"

RSpec.describe OperatingCompany, type: :model do
  it { is_expected.to belong_to(:companyable) }
  it { is_expected.to have_one(:address) }
  it { is_expected.to have_one(:contact) }
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
