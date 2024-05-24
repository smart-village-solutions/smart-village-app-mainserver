class CheckRssFeed

  def initialize(feed)
    @feed = feed
  end

  def call
    uri = "https://rss-feed-importer.smart-village.app/check_rss_config"
    data = { feed_config: @feed }
    request_service = ApiRequestService.new(uri, nil, nil, data)
    result = request_service.post_request

    return :error if result.code != "200"
    JSON.parse(result.body)
  end
end
