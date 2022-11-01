# frozen_string_literal: true

class SetupUserService
  REDIRECT_URL = "urn:ietf:wg:oauth:2.0:oob"

  def initialize(provider_name:, email:, application_name:, role:, municipality_id:, data_provider_roles: nil)
    municipality = Municipality.find(municipality_id)
    user_password = SecureRandom.alphanumeric

    data_provider = DataProvider.create(
      name: provider_name,
      description: "",
      logo: create_web_url,
      roles: data_provider_roles
    )
    user = User.create(
      email: email,
      password: user_password,
      password_confirmation: user_password,
      role: role,
      municipality: municipality
    )
    user.data_provider = data_provider
    user.save

    doorkeeper_app = Doorkeeper::Application.new(name: application_name, redirect_uri: REDIRECT_URL)
    doorkeeper_app.owner = user
    doorkeeper_app.save

    if user.id.present? && Rails.env.production?
      # Store account in 1Password.com in production
      OnePasswordService.setup(
        municipality_id: municipality.id,
        password: user_password,
        username: email
      )
    end
  end

  private

    def create_web_url
      WebUrl.create(url: "https://smart-village.solutions/wp-content/uploads/2020/09/Logo-Smart-Village-Solutions-SVS.png")
    end
end
