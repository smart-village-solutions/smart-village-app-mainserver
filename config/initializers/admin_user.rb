if ActiveRecord::Base.connection.table_exists?("users")
  Rails.application.config.to_prepare do
    User.where(email: Rails.application.credentials.admin[:email]).first_or_create(
      password: Rails.application.credentials.admin[:password],
      password_confirmation: Rails.application.credentials.admin[:password]
    )
  end
end
