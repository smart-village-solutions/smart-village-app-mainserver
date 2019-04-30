# frozen_string_literal: true

require "rails_helper"

RSpec.describe PointOfInterest, type: :model do
  it { is_expected.to have_many(:adresses) }
  it { is_expected.to have_many(:contacts) }
  it { is_expected.to have_one(:operating_company) }
  it { is_expected.to have_one(:data_provider) }
  it { is_expected.to have_many(:prices) }
  it { is_expected.to have_many(:media_contents) }
  it { is_expected.to have_many(:opening_hours) }
  it { is_expected.to have_many(:accessibilty_informations) }
  it { is_expected.to have_many(:certificates) }
  it { is_expected.to have_one(:web_url) }
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: point_of_interests
#
#  id                 :bigint(8)        not null, primary key
#  external_id        :integer
#  name               :string(255)
#  description        :string(255)
#  mobile_description :string(255)
#  active             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
