# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::DestroyAccountService, type: :service do
  let(:municipality) { create(:municipality) }
  let(:data_provider) { create(:data_provider, municipality: municipality) }
  let(:user) { create(:user, municipality: municipality, role: :user) }
  let(:destroy_service) { described_class.new(data_provider_id: data_provider&.id) }

  before do
    MunicipalityService.municipality_id = municipality.id
    user.update(data_provider: data_provider)
  end

  describe "#destroy_account" do
    subject(:destroy_account) { destroy_service.destroy_account }

    context "when data provider exists" do
      it "destroys the data provider and associated user" do
        expect { destroy_account }.to change(DataProvider, :count).by(-1).and change(User, :count).by(-1)
      end

      it "returns the destroyed data provider" do
        expect(destroy_account).to eq(data_provider)
      end
    end

    context "when data provider does not exist" do
      let(:data_provider) { nil }

      it "does not change the data provider count" do
        expect { destroy_account }.not_to change(DataProvider, :count)
      end

      it "does not change the user count" do
        expect { destroy_account }.not_to change(User, :count)
      end

      it "returns nil" do
        expect(destroy_account).to be_nil
      end
    end
  end
end
