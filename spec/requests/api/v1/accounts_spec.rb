require 'swagger_helper'

RSpec.describe "Api::V1::Accounts", type: :request do
  path "/api/v1/accounts" do
    post "Creates an account" do
      tags "Accounts"
      consumes "application/json"
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          role: { type: :string },
          name: { type: :string },
          description: { type: :string },
          notice: { type: :string },
          data_type: { type: :string },
          roles: { type: :object },
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
        required: %w[email role]
      }

      response "201", "account created" do
        let(:account) { { email: "test@example.com", role: "admin", name: "Test Account", description: "Test description", notice: "Test notice" } }
        run_test!
      end

      response "422", "invalid request" do
        let(:account) { { email: "test@example.com" } }
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
            roles: { type: :object },
            logo: {
              type: :object,
              properties: {
                url: { type: :string },
                description: { type: :string }
              }
            },
            address: {
              type: :object,
              properties: {
                addition: { type: :string },
                city: { type: :string },
                street: { type: :string },
                zip: { type: :string }
              }
            },
            contact: {
              type: :object,
              properties: {
                first_name: { type: :string },
                last_name: { type: :string },
                phone: { type: :string },
                fax: { type: :string },
                email: { type: :string }
              }
            }
          },
          required: %w[id email role name description notice]

        let(:id) { create(:data_provider).id }
        run_test!
      end

      response "404", "account not found" do
        let(:id) { "invalid" }
        run_test!
      end
    end

    put "Updates an account" do
      tags "Accounts"
      consumes "application/json"
      parameter name: :id, in: :path, type: :string
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          role: { type: :string },
          name: { type: :string },
          description: { type: :string },
          notice: { type: :string },
          data_type: { type: :string },
          roles: { type: :object },
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
        }
      }

      response "200", "account updated" do
        let(:id) { create(:data_provider).id }
        let(:account) { { email: "updated@example.com" } }
        run_test!
      end

      response "404", "account not found" do
        let(:id) { "invalid" }
        let(:account) { { email: "updated@example.com" } }
        run_test!
      end
    end

    delete "Deletes an account" do
      tags "Accounts"
      parameter name: :id, in: :path, type: :string

      response "204", "account deleted" do
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
