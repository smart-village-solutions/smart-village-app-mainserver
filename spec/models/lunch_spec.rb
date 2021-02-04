# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lunch, type: :model do
  it { is_expected.to have_many(:dates) }
  it { is_expected.to have_many(:lunch_offers) }
  it { is_expected.to belong_to(:point_of_interest) }
end

# == Schema Information
#
# Table name: lunches
#
#  id                           :bigint           not null, primary key
#  text                         :text(65535)
#  point_of_interest_id         :integer
#  point_of_interest_attributes :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
