class AddKeycloakTokenToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :keycloak_access_token, :text
    add_column :members, :keycloak_access_token_expires_at, :datetime
    add_column :members, :keycloak_refresh_token, :text
    add_column :members, :keycloak_refresh_token_expires_at, :datetime
  end
end
