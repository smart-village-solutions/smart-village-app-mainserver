# rubocop:disable all

require "swagger_helper"

RSpec.describe "members/sessions", type: :request do
  path "/members/sign_in" do
    post "Sign In a member", json: true do
      tags "Members"
      consumes "application/json"
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          member: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string },
            }
          }
        },
        required: %w[email password password_confirmation]
      }

      response "200", "member created" do
        response = {
          success: true,
          member: {
            id: 10,
            keycloak_id: "52cfe927-d8f3-48d6-82c7-6d5e67655e55",
            municipality_id: 6,
            created_at: "2024-02-14T11:04:55.638+01:00",
            updated_at: "2024-02-14T11:04:55.649+01:00",
            email: "user@example.com",
            authentication_token: "MQffbe7avPxJsKvEL8sn",
            authentication_token_created_at: "2024-02-14T11:04:55.000+01:00",
            keycloak_access_token: nil,
            keycloak_access_token_expires_at: nil,
            keycloak_refresh_token: nil,
            keycloak_refresh_token_expires_at: nil,
            preferences: {}
          }
        }
        let(:member) do
          response
        end
        example "application/json", :member, response
        run_test!
      end

      response "403", "invalid request" do
        let(:member) {
          {
            "success": false,
            "errors": "User exists with same username"
          }
        }
        example "application/json", :auth_error, {
          success: false,
          errors: "Some Error"
        }
        run_test!
      end
    end
  end
end
