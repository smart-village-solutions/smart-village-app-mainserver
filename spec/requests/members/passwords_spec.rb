# disable all cops for this file
# rubocop:disable all

require "rails_helper"
require "swagger_helper"

RSpec.describe "members/password", type: :request do
  path "/members/password" do
    post "Send password reset mail to member", json: true do
      tags "Members"
      consumes "application/json"
      # this api should be the first in swagger documentation


      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          member: {
            type: :object,
            properties: {
              email: { type: :string, format: :email }
            }
          }
        },
        required: %w[email password password_confirmation]
      }

      response "200", "member created" do
        response = {
          success: true,
          errors: nil
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
