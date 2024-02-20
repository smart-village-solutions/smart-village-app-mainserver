# frozen_string_literal: true

# Mixin to create a web url
module WebUrlCreationMixin
  extend ActiveSupport::Concern

  def create_web_url(url, description = "")
    default_url = "https://smart-village.solutions/wp-content/uploads/2020/09/Logo-Smart-Village-Solutions-SVS.png"
    WebUrl.create(url: url.presence || default_url, description: description)
  end
end
