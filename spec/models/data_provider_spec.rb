# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataProvider, type: :model do
  it { is_expected.to have_one(:address) }
  it { is_expected.to have_one(:contact) }
  it { is_expected.to belong_to(:provideable) }
end

# == Schema Information
#
# Table name: data_providers
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  logo             :string(255)
#  description      :string(255)
#  provideable_type :string(255)
#  provideable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
