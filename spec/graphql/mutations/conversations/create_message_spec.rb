# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::Conversations::CreateMessage do
  include_context "with graphql"

  subject { data['createMessage'] }
  let(:query_string) do
    <<~GQL
      mutation(
        $conversationableId: ID,
        $conversationableType: String,
        $messageText: String!,
        $conversationId: ID
      ) {
        createMessage(
          conversationableId: $conversationableId,
          conversationableType: $conversationableType,
          messageText: $messageText,
          conversationId: $conversationId
        ) {
          id
          status
          statusCode
        }
      }
    GQL
  end

  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }
  let(:member1) { create(:member, municipality_id: municipality.id) }
  let(:member2) { create(:member, municipality_id: municipality.id) }
  let(:generic_item) { create(:generic_item, member: member1) }
  let(:user) { create(:user, role: :admin, municipality: municipality) }
  
  let(:context) { { current_user: user, current_member: member2 } }
  let(:variables) {
    {
      conversationableId: generic_item.id,
      conversationableType: 'GenericItem',
      messageText: 'Hello',
    }
  }

  before do
    MunicipalityService.municipality_id = municipality.id
  end

  context "with conversationable variables sent" do
    it do
      is_expected.to eq(
        'id' => Messaging::Conversation.last.id.to_s,
        'status' => 'Message successfully created',
        'statusCode' => 200
      )
    end
  end

  context "with conversationId variable sent" do
    let(:conversation) { create(:messaging_conversation) }
    let(:variables) { { conversationId: conversation.id, messageText: 'Test message' } }

    it do
      is_expected.to eq(
        'id' => conversation.id.to_s,
        'status' => 'Message successfully created',
        'statusCode' => 200
      )
    end
  end

  context "when member does not exists in query" do
    let(:context) { { current_user: user } }

    it do
      is_expected.to eq(
        'id' => nil,
        'status' => 'Access not permitted',
        'statusCode' => 403
      )
    end
  end
end
