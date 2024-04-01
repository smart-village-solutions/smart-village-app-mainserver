# frozen_string_literal: true

# rubocop:disable all
# Class that prepares the event payload for the external service api requests
class ExternalServices::EventRecords::Preparer 
  def initialize(event)
    @event = event
  end

  def prepare_event_payload(organizer_id, place_id, external_service_id)
    @external_service = ExternalService.find(external_service_id)
    return unless @external_service

    {
      accessible_for_free: false,
      age_from: event.price_informations.map(&:age_from).compact.min,
      age_to: event.price_informations.map(&:age_to).compact.max,
      attendance_mode: "offline", # Can be "offline", "online" or "online and offline" on the external service
      booked_up: false,
      categories: prepared_categories_payload(@external_service),
      # co_organizers: { id: 0 }, We don't have co-organizers
      date_definitions: prepared_date_definitions_payload(@event),
      description: @event.description,
      expected_participants: 0,
      external_link: "",
      kid_friendly: false,
      name: @event.title,
      organizer: { id: organizer_id || 783 },
      photo: {
        copyright_text: @event.media_contents.where(content_type: :image).first.copyright,
        image_url: @event.media_contents.where(content_type: :image).first.source_url.url
      },
      place: { id: place_id },
      previous_start_date: "",
      price_info: format_price_information(@event),
      public_status: "published",
      rating: 50, # this value is not visible and used for sorting on the external service
      registration_required: false,
      status: "scheduled",
      tags: @event.tags.map(&:name),
      target_group_origin: "both",
      ticket_link: ""
    }
  end

  def prepared_organizer_payload(event)
    organizer = event.organizer
    org_address = organizer.address
    return unless organizer

    {
      name: organizer.name,
      phone: organizer.contact.phone,
      url: "",
      email: organizer.contact.email,
      fax: organizer.contact.fax,
      location: {
        city: org_address.city,
        # country: org_address.country,
        latitude: org_address.geo_location&.latitude,
        longitude: org_address.geo_location&.longitude,
        postalCode: org_address.zip,
        # state: "",
        street: org_address.street
      }
    }
  end

  # we don't have name of location because on external api this is a place
  # We should create location on external service for each address from event
  def prepared_place_payload(address)
    {
      # name: event.addresses.first.addition,
      # url: ,
      description: address.addition,
      location: {
        city: address.city,
        # country: address.country,
        latitude: address.geo_location&.latitude,
        longitude: address.geo_location&.longitude,
        postalCode: address.zip,
        # state: ,
        street: address.street
      }
    }
  end

  private

    attr_reader :event

    def prepared_date_definitions_payload(event)
      event.dates.map do |date_definition|
        {
          allday: false,
          start: date_definition.date_start,
          end: date_definition.date_end,
          recurrence_rule: ""
        }
      end
    end

    def format_price_information(event)
      price_texts = event.price_informations.map do |price|
        formatted_price = "#{price[:name]}: #{'%.2f' % price[:amount]}"
        formatted_price += " - Group Price" if price[:groupPrice]

        if price[:ageFrom] && price[:ageTo]
          formatted_price += " - Ages #{price[:ageFrom]} to #{price[:ageTo]}"
        end

        if price[:groupPrice]
          if price[:minAdultCount] && price[:maxAdultCount]
            formatted_price += " - Adults: #{price[:minAdultCount]} to #{price[:maxAdultCount]}"
          end

          if price[:minChildrenCount] && price[:maxChildrenCount]
            formatted_price += " - Children: #{price[:minChildrenCount]} to #{price[:maxChildrenCount]}"
          end
        end

        formatted_price += " - #{price[:description]}" if price[:description]
        formatted_price
      end

      price_texts.join("\n")
    end

    def prepared_categories_payload(external_service)
      category_ext_ids = ExternalServiceCategory.where(category_id: event.category_ids, external_service_id: external_service).map(&:external_id)
      category_ext_ids.compact.map do |external_id|
        { id: external_id }
      end
    end
end
