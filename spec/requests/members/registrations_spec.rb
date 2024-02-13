# disable all cops for this file
# rubocop:disable all

require "rails_helper"
require "swagger_helper"

RSpec.describe "members/registrations", type: :request do
  path "/members.json" do
    post "Creates a member", json: true do
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
              password_confirmation: { type: :string }
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
        example "application/json", :user_already_exists, {
          success: false,
          errors: "User exists with same username"
        }
        example "application/json", :password_does_not_match, {
          success: false,
          errors: "Passwort does not match"
        }
        run_test!
      end
    end

    put "Updates a member", json: true do
      tags "Members"
      consumes "application/json"
      security [Bearer: {}]
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          auth_token: { type: :string },
          member: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string },
              password_confirmation: { type: :string },
              membership_start_date: { type: :string, format: :date },
              membership_level: { type: :string },
              gender: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              birthday: { type: :string, format: :date }
            }
          }
        }
      }

      response "200", "member updated" do
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
            "errors": ""
          }
        }
        run_test!
      end
    end
  end
end
