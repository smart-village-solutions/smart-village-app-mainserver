# frozen_string_literal: true

class OnePasswordService

  # TODO: Dockerfile erweitern, sodass das dann auch online funktioniert

  # op item create --category=login --title='admin@ni-wittingen.server.smart-village.app' --vault='project-smartvillage' --url='https://ni-wittingen.server.smart-village.app' username='admin@smart-village.app' password='test'
  def self.setup(municipality_id:, password:, username:)
    municipality = Municipality.find_by(id: municipality_id)
    title = "[SaaS] #{username} #{municipality.slug}.server.smart-village.app - #{municipality.title}"
    url = "https://#{municipality.slug}.server.smart-village.app"

    system("op item create --category=login --title='#{title}' --vault='project-smartvillage' --url='#{url}' username='#{username}' password='#{password}'")
  end
end
