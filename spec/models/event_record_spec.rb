require 'rails_helper'

RSpec.describe EventRecord, type: :model do
  it { is_expected.to have_many(:adresses) }
  it { is_expected.to have_many(:contacts) }
  it { is_expected.to have_one(:organizer) }
  it { is_expected.to have_one(:data_provider) }
  it { is_expected.to have_many(:price_informations) }
  it { is_expected.to have_many(:media_contents) }
  it { is_expected.to have_one(:location) }
  it { is_expected.to have_one(:highlight) }
  it { is_expected.to have_one(:repeat_duration) }
  it { is_expected.to have_one(:accessibilty_information) }
  it { is_expected.to have_many(:urls) }
  it { is_expected.to validate_presence_of(:title) }
end
