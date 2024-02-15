# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::UpdateAccountService, type: :service do
  describe "#update_account" do
    subject(:update_account) do
      described_class.new(data_provider_id: data_provider.id, account_params: update_params).update_account
    end

    let(:municipality) { create(:municipality) }
    let(:data_provider) { create(:data_provider, :with_logo, :with_address, :with_contact, municipality: municipality) }
    let(:user) { create(:user, municipality: municipality) }

    let(:update_params) do
      {
        name: "Updated Name",
        description: "Updated Description",
        notice: "Updated Notice",
        logo_url: "https://updated-example.com/logo.png",
        logo_description: "Updated Logo Description",
        city: "Updated City",
        street: "Updated Street",
        contact_first_name: "Jane",
        contact_last_name: "Smith"
      }
    end

    before do
      MunicipalityService.municipality_id = municipality.id
      user.update(data_provider: data_provider)
    end

    it "updates the data provider and associated user with correct attributes" do
      expect { update_account }.to change { data_provider.reload.name }
        .to(update_params[:name])
        .and change(data_provider, :description).to(update_params[:description])
        .and change(data_provider, :notice).to(update_params[:notice])

      expect(data_provider.logo).to have_attributes(
        url: update_params[:logo_url],
        description: update_params[:logo_description]
      )

      expect(data_provider.address).to have_attributes(
        city: update_params[:city],
        street: update_params[:street]
      )

      expect(data_provider.contact).to have_attributes(
        first_name: update_params[:contact_first_name],
        last_name: update_params[:contact_last_name]
      )

      expect(data_provider.user).to have_attributes(
        email: user.email,
        role: user.role,
        municipality_id: user.municipality_id
      )
    end
  end
end
