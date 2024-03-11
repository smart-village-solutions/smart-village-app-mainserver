# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messaging::CreateMessageService, type: :service do
  describe "#call" do
    subject(:create_message_service) { described_class.new(params, current_member).call }

    let(:municipality) { create(:municipality) }
    let(:current_member) { create(:member, municipality_id: municipality.id) }
    let(:other_member) { create(:member, municipality_id: municipality.id) }
    let(:conversation) { create(:messaging_conversation, participants: [current_member, other_member]) }
    let(:message_text) { "Hello, this is a test message." }

    before do
      MunicipalityService.municipality_id = municipality.id
    end

    context "when the current_member is nil" do
      let(:params) { { message_text: message_text } }
      let(:current_member) { nil }

      it "returns an error response" do
        expect(create_message_service.status).to eq("Unable to create message without sender.")
        expect(create_message_service.status_code).to eq(422)
      end
    end

    context "with existing conversation" do
      let(:params) { { conversation_id: conversation.id, message_text: message_text } }

      it "creates a message in the existing conversation" do
        expect { create_message_service }.to change(Messaging::Message, :count).by(1)
        expect(create_message_service.status).to eq("Message successfully created")
        expect(Messaging::Message.last.message_text).to eq(message_text)
      end
    end

    context "when creating a new conversation" do
      let(:message_item) { create(:generic_item, member_id: other_member.id) }
      let(:params) do
        {
          conversationable_id: message_item.id,
          conversationable_type: 'GenericItem',
          message_text: message_text
        }
      end

      it "creates a new conversation and a message" do
        expect { create_message_service }.to change(Messaging::Conversation, :count).by(1)
          .and change(Messaging::Message, :count).by(1)
          .and change(Messaging::ConversationParticipant, :count).by(2)
          .and change(Messaging::Receipt, :count).by(2)

        expect(create_message_service.status).to eq("Message successfully created")
      end
    end

    context "when conversation does not exist" do
      let(:params) { { conversation_id: "fake_id", message_text: message_text } }

      it "returns an error response" do
        service_response = create_message_service
        expect(service_response.status).to eq("Conversation does not exist")
        expect(service_response.status_code).to eq(422)
      end
    end

    context "when conversationable is a member" do
      let(:sample_member) { create(:member, municipality_id: municipality.id) }
      let(:params) do
        {
          conversationable_id: sample_member.id,
          conversationable_type: 'Member',
          message_text: message_text
        }
      end

      it "returns an error response" do
        service_response = create_message_service
        expect(service_response.status).to eq("Resource owner does not exist")
        expect(service_response.status_code).to eq(422)
      end
    end
  end
end
