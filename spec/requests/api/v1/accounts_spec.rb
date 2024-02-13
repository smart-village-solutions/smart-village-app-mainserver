# disable all cops for this file
# rubocop:disable all

require "rails_helper"
require "swagger_helper"

RSpec.describe "api/v1/accounts", type: :request do
  path "/api/v1/accounts" do
    post "Creates an account" do
      tags "Accounts"
      consumes "application/json"
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string, format: :email },
          role: { type: :string },
          data_type: { type: :string },
          logo_link: {
            type: :string,
            default: "https://smart-village.solutions/wp-content/uploads/2020/09/Logo-Smart-Village-Solutions-SVS.png"
          }
        },
        required: %w[name email role data_type]
      }

      response "201", "account created" do
        let(:account) do
          {
            name: "New Account",
            email: "test@example.com",
            role: "user",
            data_type: "business_account",
            logo_link: "http://example.com/logo.png"
          }
        end
        run_test!
      end

      response "422", "invalid request" do
        let(:account) { {} }
        run_test!
      end
    end
  end
end
