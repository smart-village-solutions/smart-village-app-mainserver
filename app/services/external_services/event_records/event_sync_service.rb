# frozen_string_literal: true

# rubocop:disable all
class ExternalServices::EventRecords::EventSyncService
  def initialize(user, event)
    @user = user
    @event = event
    @auth_service = ExternalServices::AuthService.new(user)
    @external_service_preparer = ExternalServices::EventRecords::OvedaPreparer.new(event)
    @external_service = user.data_provider.external_service
  end

  # Publishes the event to the external service, including organizer and place creation.
  #
  # @return [Object]
  def create_or_update_event
    return unless access_token

    external_creds = @user.data_provider.external_service_credential

    # For the new event we should have organization_id in the external_service_credential additional_params
    organization_id = external_creds.additional_params['organization_id']

    create_path = resolve_resource_path('create', organization_id: organization_id)
    update_path = resolve_resource_path('update', event_id: event.external_id) if event.external_id.present?

    # Prepare data and create organizer and place for the event on the API
    organizer_payload = prepare_organizer_payload
    place_payload = prepare_place_payload
    organizer_id = create_external_resource("/organizers", organization_id, organizer_payload, access_token)
    place_id = create_external_resource("/places", organization_id, place_payload, access_token)

    event_payload = prepare_event_payload(organizer_id, place_id)

    request_path = event.external_id.present? ? update_path : create_path
    req_action = event.external_id.present? ? :update : :create

    response = send_request(uri: request_path, action: req_action, payload: event_payload)

    event.update(external_id: response[:id]) unless event.external_id.present? 
    event
  end

  def delete_event
    return unless access_token

    delete_path = resolve_resource_path('delete', event_id: event.id)
    send_request(uri: delete_path, action: :delete)
  end

  private

    attr_reader :user, :event, :auth_service, :external_service, :external_service_preparer

    def access_token
      @access_token ||= auth_service.obtain_access_token[:access_token]
    end

    def prepare_organizer_payload
      external_service_preparer.prepared_organizer_payload(event)
    end

    def prepare_place_payload
      external_service_preparer.prepared_place_payload(event.addresses.first)
    end

    def prepare_event_payload(organizer_id, place_id)
      external_service_preparer.prepare_event_payload(organizer_id, place_id, external_service.id)
    end

    def create_external_resource(resource_path, organization_id, payload, access_token)
      full_path = @external_service.base_uri + "/api/v1/organizations/#{organization_id}#{resource_path}"
      send_request(uri: full_path, action: :create, payload: payload)
    end

    def resolve_resource_path(action, organization_id: nil, event_id: nil)
      base_path = @external_service.resource_config['event_record'][action]
      base_path.gsub!("{organization_id}", organization_id.to_s) if organization_id
      base_path.gsub!("{event_id}", event_id.to_s) if event_id
      @external_service.base_uri + base_path
    end

    def prepared_headers
      {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json"
      }
    end

    def send_request(uri:, action: :create, payload: {})
      request_service = ApiRequestService.new(uri, nil, nil, payload, prepared_headers)

      response = case action
                 when :create
                   request_service.post_request
                 when :update
                   request_service.put_request
                 when :delete
                   request_service.delete_request
                 end

      JSON.parse(response.body, symbolize_names: true)
    end
end
