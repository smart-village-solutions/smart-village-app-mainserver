# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::Conversations::UpdateNotificationSettings do
  include_context "with graphql"

  subject { data['updateNotificationSettings'] }
  let(:query_string) do
    <<~GQL
      mutation(
        $conversationId: ID!,
        $pushNotificationEnabled: Boolean,
        $emailNotificationEnabled: Boolean,
      ) {
        updateNotificationSettings(
          conversationId: $conversationId,
          pushNotificationEnabled: $pushNotificationEnabled,
          emailNotificationEnabled: $emailNotificationEnabled,
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
  let(:generic_item) { create(:generic_item, member: member1) }
  let(:conversation) { create(:messaging_conversation, conversationable: generic_item) }
  let(:context) { { current_user: user, current_member: member1 } }
  let(:variables) { {
    conversationId: conversation.id,
    pushNotificationEnabled: false,
    emailNotificationEnabled: false
  } }

  before do
    MunicipalityService.municipality_id = municipality.id
    FactoryBot.create(:messaging_conversation_participant, member: member1, conversation: conversation)
  end

  context "update notification settings" do
    it do
      prtc = Messaging::ConversationParticipant.find_by(member: member1, conversation: conversation)
      expect(prtc.push_notification_enabled).to eq(true)
      expect(prtc.email_notification_enabled).to eq(true)
      is_expected.to eq(
        'id' => prtc.id.to_s,
        'status' => 'Notification settings successfully updated',
        'statusCode' => 200
      )
      expect(prtc.reload.push_notification_enabled).to eq(false)
      expect(prtc.reload.email_notification_enabled).to eq(false)
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
