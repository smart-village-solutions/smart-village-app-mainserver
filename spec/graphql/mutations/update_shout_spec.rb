# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Mutations::UpdateShout do
  include_context "with graphql"

  subject { data['updateShout'] }
  let(:query_string) do
    <<~GQL
      mutation(
        $id: ID!,
        $title: String,
        $description: String,
        $dateStart: String,
        $dateEnd: String,
        $timeStart: String,
        $timeEnd: String,
        $announcementTypes: [String!],
        $maxNumberOfQuota: Int,
        $participants: [ID!],
        $location: AddressInput,
        $mediaContent: MediaContentInput
      ) {
        updateShout(
          id: $id,
          title: $title,
          description: $description,
          dateStart: $dateStart,
          dateEnd: $dateEnd,
          timeStart: $timeStart,
          timeEnd: $timeEnd,
          announcementTypes: $announcementTypes,
          maxNumberOfQuota: $maxNumberOfQuota,
          participants: $participants,
          location: $location,
          mediaContent: $mediaContent,
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
    id: GenericItem.last.id,
    title: "Updated title",
    description: "Updated description",
    dateStart: 2.days.from_now.strftime("%Y-%m-%d"),
    dateEnd: 3.days.from_now.strftime("%Y-%m-%d"),
    timeStart: "07:00",
    timeEnd: "20:00",
    announcementTypes: ["category"],
    maxNumberOfQuota: 5,
    participants: [member1.id, member2.id],
    location: {
      city: "updated city",
      street: "updated street",
      geoLocation: {
        longitude: 2.0,
        latitude: 2.0
      }
    },
    mediaContent: {
      contentType: "video",
      captionText: "updated caption",
      sourceUrl: {
        url: "http://video.url.example"
      }
    }
  } }

  before do
    MunicipalityService.municipality_id = municipality.id
    item = GenericItem.create!(
      title: "Test title",
      description: "Test description",
      generic_type: GenericItem::GENERIC_TYPES[:announcement],
      generic_itemable_type: "EventRecord",
      generic_itemable_id: event_record.id,
    )

    item.opening_hours.create!(
      date_from: Date.current,
      date_to: 1.days.from_now,
      time_from: "10:00",
      time_to: "12:00"
    )

    item.categories.create!(name: "Test type")

    address = item.addresses.create!(
      city: "Test city",
      street: "Test street",
      geo_location_attributes: { longitude: 1.0, latitude: 1.0 }
    )

    item.media_contents.create!(
      content_type: "image",
      caption_text: "Test caption",
      source_url_attributes: { url: "http://test.com" }
    )

    item.create_quota!(max_quantity: 10)

    item.quota.redemptions.create!(member_id: member1.id)
  end

  context "with all variables sent" do
    it do
      is_expected.to eq(
        'id' => GenericItem.last.id.to_s,
        'title' => "Updated title",
        'description' => "Updated description",
        'dateStart' => 2.days.from_now.strftime("%Y-%m-%d"),
        'dateEnd' => 3.days.from_now.strftime("%Y-%m-%d"),
        'timeStart' => "07:00",
        'timeEnd' => "20:00",
        'organizer' => nil,
        'announcementTypes' => ["category"],
        'location' => {
          'city' => "updated city",
          'street' => "updated street",
          'geoLocation' => {
            'longitude' => 2.0,
            'latitude' => 2.0
          }
        },
        'mediaContent' => {
          'contentType' => "video",
          'captionText' => "updated caption",
          'sourceUrl' => {
            'url' => "http://video.url.example"
          }
        },
        'announcementableType' => "EventRecord",
        'announcementableId' => event_record.id.to_s,
        'maxNumberOfQuota' => 5,
        'participants' => [member1.id.to_s, member2.id.to_s]
      )
    end
  end
end
