Devise::TokenAuthenticatable.setup do |config|
  # enables the expiration of a token after a specified amount of time,
  # requires an additional field on the model: `authentication_token_created_at`
  # defaults to nil
  config.token_expires_in = 1.day
  config.should_ensure_authentication_token = true
  config.should_reset_authentication_token = true
end
