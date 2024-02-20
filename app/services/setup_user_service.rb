# frozen_string_literal: true

class SetupUserService
  include WebUrlCreationMixin

  REDIRECT_URL = "urn:ietf:wg:oauth:2.0:oob"

  def initialize(
    provider_name:,
    description: "",
    logo_url: nil,
    email:,
    application_name:,
    role:,
    municipality_id:,
    data_provider_roles: nil
  )
    municipality = Municipality.find(municipality_id)
    user_password = SecureRandom.alphanumeric

    data_provider = DataProvider.create(
      name: provider_name,
      description: description,
      logo: create_web_url(logo_url),
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
end
