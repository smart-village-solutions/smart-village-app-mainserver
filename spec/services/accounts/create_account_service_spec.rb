require 'rails_helper'

RSpec.describe Accounts::CreateAccountService, type: :service do
  describe '#create_account' do
    let(:account_params) do
      {
        email: 'test@example.com',
        password: 'password',
        role: 'user',
        name: 'Test Provider',
        data_type: "business_account",
        data_provider_roles: {
          role_point_of_interest => true,
          role_tour => true,
          role_news_item => false,
          role_event_record => false,
          role_voucher => false,
          role_noticeboard => true,
          role_encounter_support => true,
          role_survey => true,
          role_offer => true,
          role_job => true
        }
      }
    end

    provider_name: "DataProviderName",
        description: "DataProviderDescription",
        logo_url: "http://example.com/logo.png",
        ,
        

    it 'creates a user and a data provider' do
      expect { described_class.new(account_params: account_params).create_account }.to change { User.count }.by(1).and change { DataProvider.count }.by(1)
    end

    it 'assigns the correct role to the user' do
      user = described_class.new(account_params: account_params).create_account
      expect(user.role).to eq('user')
    end

    it 'raises an error if the role is invalid' do
      account_params[:role] = 'invalid_role'
      expect { described_class.new(account_params: account_params).create_account }.to raise_error(RoleValidatorMixin::InvalidRoleError)
    end

    # Add more specs as needed to cover other aspects of the service's behavior
  end
end
