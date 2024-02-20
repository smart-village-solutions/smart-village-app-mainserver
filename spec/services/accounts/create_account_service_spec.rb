# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::CreateAccountService, type: :service do
  describe "#create_account" do
    subject(:create_account) { described_class.new(account_params: account_params, municipality_id: municipality.id).create_account }

    let(:municipality) { create(:municipality) }

    let(:account_params) do
      {
        email: "test@example.com",
        role: "user",
        name: "Test Account",
        description: "Test Description",
        notice: "Test Notice",
        logo_url: "https://example.com/logo.png",
        logo_description: "Test Logo Description",
        addition: "Test Addition",
        city: "Test City",
        street: "Test Street",
        zip: "12345",
        contact_first_name: "John",
        contact_last_name: "Doe",
        contact_phone: "123-456-7890",
        contact_fax: "123-456-7891",
        contact_email: "contact@example.com"
      }
    end

    before do
      MunicipalityService.municipality_id = municipality.id
    end

    it "creates a new user and data provider with correct attributes" do
      expect { create_account }.to change(User, :count).by(1).and change(DataProvider, :count).by(1)

      created_user = User.last
      expect(created_user).to have_attributes(
        email: account_params[:email],
        role: account_params[:role],
        municipality_id: municipality.id
      )

      created_data_provider = DataProvider.last
      expect(created_data_provider).to have_attributes(
        name: account_params[:name],
        description: account_params[:description],
        notice: account_params[:notice],
        data_type: "business_account"
      )

      expect(created_data_provider.logo).to have_attributes(
        url: account_params[:logo_url],
        description: account_params[:logo_description]
      )

      expect(created_data_provider.address).to have_attributes(
        addition: account_params[:addition],
        city: account_params[:city],
        street: account_params[:street],
        zip: account_params[:zip]
      )

      expect(created_data_provider.contact).to have_attributes(
        first_name: account_params[:contact_first_name],
        last_name: account_params[:contact_last_name],
        phone: account_params[:contact_phone],
        fax: account_params[:contact_fax],
        email: account_params[:contact_email]
      )
    end

    context "with invalid account params" do
      it "raises ActiveRecord::RecordInvalid error when email is missing" do
        invalid_params = account_params.merge(email: nil)
        expect { described_class.new(account_params: invalid_params, municipality_id: municipality.id).create_account }
          .to raise_error(ActiveRecord::RecordInvalid, /Validation failed: Email can't be blank/)
      end

      it "raises ActiveRecord::RecordInvalid error when email already exists" do
        existing_user = create(:user)
        invalid_params = account_params.merge(email: existing_user.email)
        expect { described_class.new(account_params: invalid_params, municipality_id: municipality.id).create_account }
          .to raise_error(ActiveRecord::RecordInvalid, /Validation failed: Email has already been taken/)
      end

      it "raises ArgumentError error when role is not allowed" do
        invalid_params = account_params.merge(role: "admin")
        expect { described_class.new(account_params: invalid_params, municipality_id: municipality.id).create_account }
          .to raise_error(ArgumentError, /Role not allowed/)
      end
    end
  end
end
