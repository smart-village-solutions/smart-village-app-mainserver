# frozen_string_literal: true

namespace :setup do
  desc "Sets default categories to all elements of a given data_provider and data_resource_type"
  task accounts: :environment do
    admin_password = SecureRandom.alphanumeric
    app_password = SecureRandom.alphanumeric

    puts "Admin: #{admin_password}"
    puts "App: #{app_password}"

    redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

    # Create Administrator
    admin_data_provider = DataProvider.create(name: "Administrator", description: "", logo: create_web_url)
    admin = User.create(email: "admin@smart-village.app", password: admin_password, password_confirmation: admin_password, role: 1)
    admin.data_provider = admin_data_provider
    admin.save
    doorkeeper_app = Doorkeeper::Application.new name: "Administrator", redirect_uri: redirect_uri
    doorkeeper_app.owner = admin
    doorkeeper_app.save
    puts "Admin created with id: #{admin.id}"

    # Create Mobile App
    app_data_provider = DataProvider.create(name: "Mobile App", description: "", logo: create_web_url)
    app_user = User.create(email: "mobile-app@smart-village.app", password: app_password, password_confirmation: app_password, role: 2)
    app_user.data_provider = app_data_provider
    app_user.save
    doorkeeper_app = Doorkeeper::Application.new name: "Mobile App (iOS/Android)", redirect_uri: redirect_uri, confidential: false
    doorkeeper_app.owner = app_user
    doorkeeper_app.save
    puts "MobileApp created with id: #{app_user.id}"
  end

  def create_web_url
    WebUrl.create(url: "https://smart-village.solutions/wp-content/uploads/2020/09/Logo-Smart-Village-Solutions-SVS.png")
  end
end
