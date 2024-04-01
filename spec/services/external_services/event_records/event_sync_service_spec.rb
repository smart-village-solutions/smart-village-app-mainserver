require "rails_helper"

RSpec.describe ExternalServices::EventRecords::EventSyncService do
  let(:user) { instance_double(User, data_provider: data_provider) }
  let(:event) { instance_double(EventRecord, id: 1, external_id: nil, addresses: [address]) }
  let(:data_provider) { instance_double(DataProvider, external_service: external_service) }
  let(:external_service) { instance_double(ExternalService, external_service_credential: credential, base_uri: "https://example.com", resource_config: resource_config, id: 999) }
  let(:credential) { instance_double(ExternalServiceCredential, organization_id: 123) }
  let(:address) { instance_double(Address) }
  let(:auth_service) { instance_double(ExternalServices::AuthService, obtain_access_token: { access_token: "token" }) }
  let(:external_service_preparer) { instance_double(ExternalServices::EventRecords::Preparer) }
  let(:resource_config) { {"event_record" => {"create" => "/events", "update" => "/events/{event_id}", "delete" => "/events/{event_id}"}} }
  let(:api_request_service) { instance_double(ApiRequestService) }

  before do
    allow(ExternalServices::AuthService).to receive(:new).with(user).and_return(auth_service)
    allow(ExternalServices::EventRecords::Preparer).to receive(:new).with(event).and_return(external_service_preparer)
    allow(external_service_preparer).to receive(:prepared_organizer_payload).and_return({})
    allow(external_service_preparer).to receive(:prepared_place_payload).and_return({})
    allow(external_service_preparer).to receive(:prepare_event_payload).and_return({})
    allow(ApiRequestService).to receive(:new).and_return(api_request_service)
    allow(api_request_service).to receive(:post_request).and_return(OpenStruct.new(body: { id: 2 }.to_json))
    allow(api_request_service).to receive(:put_request).and_return(OpenStruct.new(body: { id: 2 }.to_json))
    allow(api_request_service).to receive(:delete_request).and_return(OpenStruct.new(body: {}.to_json))
  end

  describe "#create_or_update_event" do
    it "creates a new event when external_id is not present" do
      service = described_class.new(user, event)
      expect(event).to receive(:update).with(external_id: 2)
      service.create_or_update_event
    end

    context "when updating an event" do
      let(:event) { instance_double(EventRecord, id: 1, external_id: "2", addresses: [address]) }

      it "updates the event when external_id is present" do
        service = described_class.new(user, event)
        expect(event).to_not receive(:update).with(external_id: 2)
        service.create_or_update_event
      end
    end
  end

  describe "#delete_event" do
    let(:api_request_service) { instance_double(ApiRequestService, delete_request: OpenStruct.new(body: {}.to_json)) }

    it "deletes the event" do
      service = described_class.new(user, event)
      expect { service.delete_event }.not_to raise_error
    end
  end
end
