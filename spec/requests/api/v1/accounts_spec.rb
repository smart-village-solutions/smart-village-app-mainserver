# rubocop:disable all
require 'swagger_helper'

RSpec.describe 'Accounts API', type: :request do
  include_context "common setup for accounts API(account_manager user role)"

  path '/api/v1/accounts/{id}' do
    get 'Retrieves an account' do
      include_examples "an unauthorized request"

      tags 'Accounts'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string, description: 'ID of the account to retrieve'

      response '200', 'account found' do
        schema type: :object,
               properties: {
                 account: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string, nullable: true },
                     description: { type: :string, nullable: true },
                     roles: { type: :object },
                     data_type: { type: :string },
                     notice: { type: :string, nullable: true },
                     external_service: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          name: { type: :string }
                        }
                      },
                     user: {
                        type: :object,
                        properties: {
                          email: { type: :string },
                          role: { type: :string }
                        }
                      },
                      logo: {
                        type: :object,
                        properties: {
                          url: { type: :string },
                          description: { type: :string, nullable: true }
                        }
                      },
                      address: {
                        type: :object,
                        properties: {
                          addition: { type: :string, nullable: true },
                          city: { type: :string, nullable: true },
                          street: { type: :string, nullable: true },
                          zip: { type: :string, nullable: true }
                        }
                      },
                      contact: {
                        type: :object,
                        properties: {
                          first_name: { type: :string, nullable: true },
                          last_name: { type: :string, nullable: true },
                          phone: { type: :string, nullable: true },
                          fax: { type: :string, nullable: true },
                          email: { type: :string, nullable: true }
                        }
                      }
                   },
                   required: ['id', 'name', 'description', 'roles', 'data_type', 'notice', 'user', 'logo', 'address', 'contact', 'external_service']
                 }
               },
               required: ['account']

        run_test!
      end

      response '404', 'account not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end

  path '/api/v1/accounts' do
    post 'Creates an account' do
      tags 'Accounts'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          role: { type: :string, example: 'user or restricted' },
          name: { type: :string, example: 'DataProvider Name' },
          description: { type: :string, example: 'Description of the DataProvider' },
          notice: { type: :string, example: 'Notice text' },
          data_type: { type: :string, example: "Data type description('general_importer or business_account, business_account by default')" },
          logo_url: { type: :string, example: 'http://example.com/logo.png' },
          logo_description: { type: :string, example: 'Logo description' },
          addition: { type: :string, example: 'Additional info' },
          city: { type: :string, example: 'City Name' },
          street: { type: :string, example: 'Street Name' },
          zip: { type: :string, example: 'ZIP Code' },
          contact_first_name: { type: :string, example: 'First Name' },
          contact_last_name: { type: :string, example: 'Last Name' },
          contact_phone: { type: :string, example: 'Phone Number' },
          contact_fax: { type: :string, example: 'Fax Number' },
          contact_email: { type: :string, example: 'contact@example.com' },
          external_service_id: { type: :string, example: 'External Service ID' },
          client_key: { type: :string, example: 'Client Key' },
          client_secret: { type: :string, example: 'Client Secret' }
        },
        required: ['email', 'role', 'name']
      }

      response '201', 'account created' do
        let(:account) do
          {
            email: 'new_user@example.com',
            role: 'restricted',
            name: 'New DataProvider',
            description: 'This is a description of the new DataProvider'
          }
        end

        run_test! do |response|
          expect_attribute_value(response, ['account', 'name'], 'New DataProvider')
          expect_attribute_value(response, ['account', 'user', 'role'], 'restricted')
          expect_attribute_value(response, ['account', 'user', 'email'], 'new_user@example.com')
        end
      end

      response '422', 'unprocessable entity' do
        let(:account) do
          {
            email: 'new_user@example.com',
            role: 'admin'
          }
        end
        run_test! do |response|
          expect_error_message(response, "Role not allowed")
        end
      end
    end
  end

  path '/api/v1/accounts/{id}' do
    put 'Updates an account' do
      tags 'Accounts'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string, description: 'ID of the account to update'
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          email: { type: :string },
          role: { type: :string },
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
          contact_email: { type: :string },
          external_service_id: { type: :string },
          client_key: { type: :string },
          client_secret: { type: :string }
        },
        required: ['name']
      }

      let(:id) { data_provider.id }
      let(:account) do
        {
          name: 'Updated DataProvider',
          description: 'Updated description',
          email: 'updated@examle.com',
          role: 'restricted',
          logo_url: 'http://example.com/updated_logo.png',
          city: 'Updated City',
          contact_first_name: 'Updated First Name'
        }
      end

      response '200', 'account updated' do
        let(:Authorization) { "Bearer #{auth_token.token}" }
        run_test! do |response|
          expect_attribute_value(response, ['account', 'name'], 'Updated DataProvider')
          expect_attribute_value(response, ['account', 'description'], 'Updated description')
          expect_attribute_value(response, ['account', 'user', 'email'], 'updated@examle.com')
          expect_attribute_value(response, ['account', 'user', 'role'], 'restricted')
          expect_attribute_value(response, ['account', 'logo', 'url'], 'http://example.com/updated_logo.png')
          expect_attribute_value(response, ['account', 'address', 'city'], 'Updated City')
          expect_attribute_value(response, ['account', 'contact', 'first_name'], 'Updated First Name')
        end
      end
    end
  end
end
