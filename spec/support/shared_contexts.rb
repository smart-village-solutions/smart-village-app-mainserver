# frozen_string_literal: true

RSpec.shared_context "common setup for accounts API(account_manager user role)", shared_context: :metadata do
  let!(:municipality) { create(:municipality) }
  let!(:account_manager) { create(:user, municipality: municipality, role: :account_manager) }

  let!(:data_provider) { create(:data_provider, user: create(:user, municipality: municipality), municipality: municipality) }
  let!(:logo) { create(:web_url, web_urlable: data_provider) }
  let!(:contact) { create(:contact, contactable: data_provider) }
  let!(:address) { create(:address, addressable: data_provider) }

  let(:doorkeeper_app) { Doorkeeper::Application.create!(name: "User app", redirect_uri: "urn:ietf:wg:oauth:2.0:oob", owner: account_manager) }
  let(:auth_token) { Doorkeeper::AccessToken.create!(application_id: doorkeeper_app.id, resource_owner_id: account_manager.id) }
  let(:Authorization) { "Bearer #{auth_token.token}" }
  let(:id) { data_provider.id }

  before do
    MunicipalityService.municipality_id = municipality.id
    host! "#{municipality.slug}.#{ADMIN_URL}"
  end
end
