# frozen_string_literal: true
require "swagger_helper"

RSpec.describe "Accounts API", type: :request do
  path "/api/v1/accounts" do
    post "Creates an account" do
      tags "Accounts"
      consumes "application/json"
      security [{ bearerAuth: [] }]
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          role: { type: :string },
          name: { type: :string },
          description: { type: :string },
          notice: { type: :string },
          data_type: { type: :string },
          logo_url: { type: :string },
          logo_description: { type: :string },
          addition: { type: :string },
          city: { type: :string },
          street: { type: :string },
          zip: { type: :string },
          contact_first_name: { type: :string },
          contact_last_name: { type: :string },
          contact_phone: { type: :string },
          contact_fax: { type: :string },
          contact_email: { type: :string }
        },
        required: %w[email role name]
      }

      let(:municipality) { create(:municipality) }
      let(:user) { create(:user, role: :account_manager) }
      let(:token) {}

      before do
        MunicipalityService.municipality_id = municipality.id
        user.update(municipality: municipality)
      end

      response "201", "account created" do
        let(:"Authorization") { "Bearer #{}" }
        let(:account) do
          {
            email: "example@dev.dev",
            role: "user",
            name: "Test Account",
            description: "Test Description",
            notice: "Test Notice",
            data_type: "business_account",
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
            contact_email: "contact_test@dev.dev"
          }
        end
        run_test!
      end

      response "422", "invalid request" do
        let(:account) { { email: nil } }
        run_test!
      end
    end
  end

  path "/api/v1/accounts/{id}" do
    get "Retrieves an account" do
      tags "Accounts"
      produces "application/json"
      parameter name: :id, in: :path, type: :string

      response "200", "account found" do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            role: { type: :string },
            name: { type: :string },
            description: { type: :string },
            notice: { type: :string },
            data_type: { type: :string },
            logo_url: { type: :string },
            logo_description: { type: :string },
            addition: { type: :string },
            city: { type: :string },
            street: { type: :string },
            zip: { type: :string },
            contact_first_name: { type: :string },
            contact_last_name: { type: :string },
            contact_phone: { type: :string },
            contact_fax: { type: :string },
            contact_email: { type: :string }
          },
          required: %w[id email role name description data_type]

        let(:id) { create(:data_provider).id }
        run_test!
      end

      response "404", "account not found" do
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
