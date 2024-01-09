# frozen_string_literal: true

class UptimeRobotService
  UPTIME_ROBOT_API_URL = "https://api.uptimerobot.com/v2"
  MONITOR_TYPES = { http: 1, keyword: 2, ping: 3 }

  def initialize(api_key:, alert_contacts:, slug:)
    @api_key = api_key
    @alert_contacts = alert_contacts
    @slug = slug
  end

  # /newMonitor
  def create_monitors
    create_single_monitor("SVA - #{@slug} Mainserver", "https://#{@slug}.server.smart-village.app", MONITOR_TYPES[:http])
    create_single_monitor("SVA - #{@slug} CMS", "https://cms.#{@slug}.smart-village.app", MONITOR_TYPES[:http])
    create_single_monitor("SVA - #{@slug} Json2Graphql", "https://json.#{@slug}.json.smart-village.app/status", MONITOR_TYPES[:http])
    create_single_monitor("SVA - #{@slug} Json2Graphql", "https://#{@slug}.json.smart-village.app/status", MONITOR_TYPES[:keyword], '<span class="state">OK</span>')
  end

  # curl -X POST
  #   -H "Cache-Control: no-cache"
  #   -H "Content-Type: application/x-www-form-urlencoded"
  #   -d 'api_key=enterYourAPIKeyHere&format=json&type=1&url=http://myMonitorURL.com&friendly_name=My Monitor'
  #   "https://api.uptimerobot.com/v2/newMonitor"
  def create_single_monitor(name, monitor_url, monitor_type, keyword_value = nil)
    data = {
      format: "json",
      api_key: @api_key,
      friendly_name: name,
      url: monitor_url,
      type: monitor_type,
      alert_contacts: @alert_contacts
    }

    if keyword_value.present?
      data[:keyword_value] = keyword_value
      data[:keyword_type] = 2
    end

    uri = "#{UPTIME_ROBOT_API_URL}/newMonitor?api_key=#{@api_key}"
    request_service = ApiRequestService.new(uri, nil, nil, data)
    result = request_service.post_request
  end
end
