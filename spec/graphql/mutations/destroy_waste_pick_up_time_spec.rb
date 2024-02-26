# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::DestroyWastePickUpTime do
  include_context "with graphql"

  subject { data['destroyWastePickUpTime'] }
  let(:query_string) do
    <<~GQL
      mutation($pickupDate: String, $wasteLocationType: WasteLocationTypeInput) {
        destroyWastePickUpTime(
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

    # second municipality
    second_municipality = create(:municipality, slug: 'second', title: 'second')
    addr_sec = Address.create!(street: 'Fake street', zip: '00123')
    wl_sec = Waste::LocationType.create!(waste_type: 'residual', address: addr_sec, municipality_id: second_municipality.id)
    Waste::PickUpTime.create!(pickup_date: 1.days.ago, waste_location_type_id: wl_sec.id, municipality_id: second_municipality.id)
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
      # Check that we have 5 records in the database at all
      expect(Waste::PickUpTime.unscoped.count).to eq(5)

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

  context "with only waste type provided" do
    let(:variables) { { wasteLocationType: { wasteType: "paper" } } }

    it do
      is_expected.to eq(
        'id' => nil,
        'status' => '2 records destroyed',
        'statusCode' => 200
      )
    end
  end

  context "with only zip code provided" do
    let(:variables) {
      {
        wasteLocationType: {
          address: {
            zip: "13088"
          }
        }
      }
    }

    it do
      # Check that we have 5 records in the database at all
      expect(Waste::PickUpTime.unscoped.count).to eq(5)

      is_expected.to eq(
        'id' => nil,
        'status' => '2 records destroyed',
        'statusCode' => 200
      )
    end
  end

  context "with only street provided" do
    let(:variables) {
      {
        wasteLocationType: {
          address: {
            street: "Gounodstrasse"
          }
        }
      }
    }

    it do
      is_expected.to eq(
        'id' => nil,
        'status' => '1 records destroyed',
        'statusCode' => 200
      )
    end
  end

  context "user without admin role" do
    let(:user) { create(:user, role: :user, municipality: municipality) }

    it do
      expect { subject }.to raise_error(RuntimeError, "Access not permitted")
    end
  end
end
