# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::Conversations::MarkMessagesAsRead do
  include_context "with graphql"

  subject { data['markMessagesAsRead'] }
  let(:query_string) do
    <<~GQL
      mutation(
        $messageId: ID,
        $conversationId: ID,
        $updateAllMessages: Boolean,
      ) {
        markMessagesAsRead(
          messageId: $messageId,
          conversationId: $conversationId,
          updateAllMessages: $updateAllMessages,
        ) {
          id
          status
          statusCode
        }
      }
    GQL
  end

  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }
  let(:user) { create(:user, role: :admin, municipality: municipality) }
  let(:member1) { create(:member, municipality_id: municipality.id) }
  let(:member2) { create(:member, municipality_id: municipality.id) }
  let(:context) { { current_user: user, current_member: member1 } }
  let(:variables) { {} }

  before do
    MunicipalityService.municipality_id = municipality.id
    generic_item = create(:generic_item, member: member2)
    conversation = FactoryBot.create(:messaging_conversation, conversationable: generic_item)
    message1 = FactoryBot.create(:messaging_message, conversation_id: conversation.id, sender_id: member1.id)
    message2 = FactoryBot.create(:messaging_message, conversation_id: conversation.id, sender_id: member2.id)
    message3 = FactoryBot.create(:messaging_message, conversation_id: conversation.id, sender_id: member1.id)

    receipt1 = FactoryBot.create(:messaging_receipt, message_id: message1.id, member: member1)
    receipt2 = FactoryBot.create(:messaging_receipt, message_id: message2.id, member: member2)
    receipt3 = FactoryBot.create(:messaging_receipt, message_id: message3.id, member: member1)
  end

  context "update one message" do
    let(:msg) { Messaging::Message.find_by(sender_id: member1.id) }
    let(:variables) { { messageId: msg.id } }

    it do
      receipt = msg.receipts.find_by(member: member1, message_id: msg.id)
      expect(receipt.read).to eq(false)
      is_expected.to eq(
        'id' => msg.id.to_s,
        'status' => 'Message successfully marked as read',
        'statusCode' => 200
      )
      expect(receipt.reload.read).to eq(true)
    end
  end

  context "update all messages in conversation" do
    let(:conv) { Messaging::Conversation.last }
    let(:variables) { { conversationId: conv.id, updateAllMessages: true } }

    it do
      receipts = Messaging::Receipt.where(message_id: conv.messages.pluck(:id), member: member1)
      expect(receipts.pluck(:read)).to eq([false, false])
      is_expected.to eq(
        'id' => conv.id.to_s,
        'status' => 'Message successfully marked as read',
        'statusCode' => 200
      )
      expect(receipts.reload.pluck(:read)).to eq([true, true])
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
