# frozen_string_literal: true

# Documentation for Members::OmniauthCallbacksController
class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include MunicipalityAuthorization

  # GET|POST /member/auth/keycloak_openid
  def keycloak_openid # rubocop:disable Metrics/AbcSize
    @member = Member.from_omniauth(session_state: params["session_state"], session_code: params["code"])

    if @member.present? && @member.persisted?
      sign_in @member
      set_flash_message(:notice, :success, kind: "Keycloak")
      redirect_to "/member"
    else
      set_flash_message(:alert, :failure, kind: "Keycloak", reason: "unknown")
      redirect_to new_member_registration_url
    end
  end

  def passthru
    keycloak_url = MunicipalityService.settings["member_keycloak_url"]
    keycloak_realm = MunicipalityService.settings["member_keycloak_realm"]
    keycloak_client_id = MunicipalityService.settings["member_keycloak_client_id"]
    callback_url = CGI.escape(Member.redirect_uri)

    redirect_to "#{keycloak_url}/realms/#{keycloak_realm}/protocol/openid-connect/auth?response_type=code&client_id=#{keycloak_client_id}&redirect_uri=#{callback_url}&scope=openid"
  end

  def failure
    redirect_to root_path
  end
end
