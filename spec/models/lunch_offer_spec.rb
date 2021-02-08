# frozen_string_literal: true

require "rails_helper"

RSpec.describe LunchOffer, type: :model do
  it { is_expected.to belong_to(:lunch) }
end

# == Schema Information
#
# Table name: lunch_offers
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  price      :string(255)
#  lunch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
