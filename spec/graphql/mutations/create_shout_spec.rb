# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::CreateShout do
  include_context "with graphql"

  subject { data['createShout'] }
  let(:query_string) do
    <<~GQL
      mutation(
        $title: String,
        $description: String,
        $dateStart: String,
        $dateEnd: String,
        $timeStart: String,
        $timeEnd: String,
        $announcementTypes: [String!],
        $maxNumberOfQuota: Int,
        $quotaVisibility: String,
        $participants: [ID!],
        $location: AddressInput,
        $mediaContent: MediaContentInput,
        $announcementableType: String!,
        $announcementableId: String!
      ) {
        createShout(
          title: $title,
          description: $description,
          dateStart: $dateStart,
          dateEnd: $dateEnd,
          timeStart: $timeStart,
          timeEnd: $timeEnd,
          announcementTypes: $announcementTypes,
          maxNumberOfQuota: $maxNumberOfQuota,
          quotaVisibility: $quotaVisibility,
          participants: $participants,
          location: $location,
          mediaContent: $mediaContent,
          announcementableType: $announcementableType,
          announcementableId: $announcementableId
        ) {
          id
          title
          description
          dateStart
          dateEnd
          timeStart
          timeEnd
          organizer {
            organizerType
            organizerId
          }
          announcementTypes
          location {
            city
            street
            geoLocation {
              longitude
              latitude
            }
          }
          mediaContent {
            contentType
            captionText
            sourceUrl {
              url
            }
          }
          announcementableType
          announcementableId
          maxNumberOfQuota
          quotaVisibility
          participants
        }
      }
    GQL
  end

  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }
  let(:data_pr) { create(:data_provider, municipality: municipality) }
  let(:user) { create(:user, role: :admin, municipality: municipality, data_provider: data_pr) }
  let!(:event_record) { create(:event_record, title: 'Event 1', data_provider_id: data_pr.id) }
  let(:member1) { create(:member, municipality_id: municipality.id) }
  let(:member2) { create(:member, municipality_id: municipality.id) }

  let(:context) { { current_user: user } }
  let(:variables) { {
    title: "Test title",
    description: "Test description",
    dateStart: Date.current.strftime("%Y-%m-%d"),
    dateEnd: 1.days.from_now.strftime("%Y-%m-%d"),
    timeStart: "10:00",
    timeEnd: "12:00",
    announcementTypes: ["Test type"],
    maxNumberOfQuota: 10,
    quotaVisibility: "public_visibility",
    participants: [member1.id, member2.id],
    location: {
      city: "Test city",
      street: "Test street",
      geoLocation: {
        longitude: 1.0,
        latitude: 1.0
      }
    },
    mediaContent: {
      contentType: "image",
      captionText: "Test caption",
      sourceUrl: {
        url: "http://test.com"
      }
    },
    announcementableType: "EventRecord",
    announcementableId: event_record.id.to_s
  } }

  before do
    MunicipalityService.municipality_id = municipality.id
  end

  context "with all variables sent" do
    it do
      is_expected.to eq(
        'id' => GenericItem.last.id.to_s,
        'title' => "Test title",
        'description' => "Test description",
        'dateStart' => Date.current.strftime("%Y-%m-%d"),
        'dateEnd' => 1.days.from_now.strftime("%Y-%m-%d"),
        'timeStart' => "10:00",
        'timeEnd' => "12:00",
        'organizer' => {
          'organizerType' => "data_provider",
          'organizerId' => data_pr.id.to_s
        },
        'announcementTypes' => ["Test type"],
        'location' => {
          'city' => "Test city",
          'street' => "Test street",
          'geoLocation' => {
            'longitude' => 1.0,
            'latitude' => 1.0
          }
        },
        'mediaContent' => {
          'contentType' => "image",
          'captionText' => "Test caption",
          'sourceUrl' => {
            'url' => "http://test.com"
          }
        },
        'announcementableType' => "EventRecord",
        'announcementableId' => event_record.id.to_s,
        'maxNumberOfQuota' => 10,
        'quotaVisibility' => "public_visibility",
        'participants' => [member1.id.to_s, member2.id.to_s]
      )
    end
  end
end
