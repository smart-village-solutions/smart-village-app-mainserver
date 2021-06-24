class FacebookService

  def self.send_post_to_page(resource_id:, resource_type:)
    resource = resource_type.constantize.find_by(id: resource_id)
    return unless resource

    setting = resource.settings
    return if setting.blank?
    return unless setting.fetch("post_to_facebook", "false") == "true"

    facebook_page_id = setting.fetch("facebook_page_id", nil)
    return if facebook_page_id.blank?

    facebook_page_access_token = setting.fetch("facebook_page_access_token", nil)
    return if facebook_page_access_token.blank?

    graph = Koala::Facebook::API.new(facebook_page_access_token)

    if resource.respond_to?(:content_for_facebook)
      data_to_send = resource.content_for_facebook
      graph.put_connections(facebook_page_id, "feed", data_to_send)
    end
  end
end
