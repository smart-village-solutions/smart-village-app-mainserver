# == Schema Information
#
# Table name: adresses
#
#  id              :bigint(8)        not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  adressable_type :string(255)
#  adressable_id   :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Adress, type: :model do
  it { should belong_to(:adressable) }
  it { should have_one(:geo_location) }
  it { should allow_value("test").for(:addition) }
  it { should allow_value("Berlin").for(:city) }
  it { should allow_value("Musterstraße 123").for(:street) }
  it { should allow_value("12051").for(:zip) }
  it { should allow_value("PointOfInterest").for(:adressable_type) }
  it { should allow_value(2).for(:adressable_id) }
end
