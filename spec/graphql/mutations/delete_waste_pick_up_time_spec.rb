# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::DeleteWastePickUpTime do
  include_context "with graphql"

  subject { data['deleteWastePickUpTime'] }
  let(:query_string) do
    <<~GQL
      mutation($pickupDate: String, $wasteLocationType: WasteLocationTypeInput) {
        deleteWastePickUpTime(
          pickupDate: $pickupDate,
          wasteLocationType: $wasteLocationType
        ) {
          id
          status
          statusCode
        }
      }
    GQL
  end
  
  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }
  let(:user) { create(:user, role: :admin, municipality: municipality) }
  let(:context) { { current_user: user } }
  let(:variables) { {
    pickupDate: "02.01.2021",
    wasteLocationType: {
      wasteType: "paper",
      address: {
        street: "Gounodstrasse",
        zip: "13088"
      }
    }
  } }

  before do
    MunicipalityService.municipality_id = municipality.id

    addr1 = Address.create!(street: 'Gounodstrasse', zip: '13088')
    addr2 = Address.create!(street: 'Bublgum', zip: '17022')
    addr3 = Address.create!(street: 'Ambasador', zip: '13088')

    wl1 = Waste::LocationType.create!(waste_type: 'paper', address: addr1, municipality_id: municipality.id)
    wl4 = Waste::LocationType.create!(waste_type: 'paper', address: addr2, municipality_id: municipality.id)
    wl2 = Waste::LocationType.create!(waste_type: 'recyclable', address: addr2, municipality_id: municipality.id)
    wl3 = Waste::LocationType.create!(waste_type: 'residual', address: addr3, municipality_id: municipality.id)

    date = Date.parse("02.01.2021")

    Waste::PickUpTime.create!(pickup_date: date, waste_location_type_id: wl1.id, municipality_id: municipality.id)
    Waste::PickUpTime.create!(pickup_date: date, waste_location_type_id: wl2.id, municipality_id: municipality.id)
    Waste::PickUpTime.create!(pickup_date: 1.days.ago, waste_location_type_id: wl3.id, municipality_id: municipality.id)
    Waste::PickUpTime.create!(pickup_date: 1.days.ago, waste_location_type_id: wl4.id, municipality_id: municipality.id)
  end

  context "with all variables sent" do
    it do
      is_expected.to eq(
        'id' => nil,
        'status' => '1 records destroyed',
        'statusCode' => 200
      )
    end
  end

  context "with empty variables sent" do
    let(:variables) { {} }

    it do
      is_expected.to eq(
        'id' => nil,
        'status' => '4 records destroyed',
        'statusCode' => 200
      )
    end
  end

  context "with invalid pickup date" do
    let(:variables) { { pickupDate: "34/17/2021" } }

    it do
      expect(errors[0]['message']).to eq(
        "Invalid pickup_date format. Please use valid date format 'YYYY-MM-DD' or 'DD.MM.YYYY'."
      )
    end
  end

  context "with only waste type" do
    let(:variables) { { wasteLocationType: { wasteType: "paper" } } }

    it do
      is_expected.to eq(
        'id' => nil,
        'status' => '2 records destroyed',
        'statusCode' => 200
      )
    end
  end
end
