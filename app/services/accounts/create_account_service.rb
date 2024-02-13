# frozen_string_literal: true

# Service to create a new account(create a new user and data provider)
class Accounts::CreateAccountService
  def initialize(account_params: {}, municipality_id: nil)
    @account_params = account_params
    @municipality_id = municipality_id || MunicipalityService.municipality_id
    @municipality = Municipality.find_by(municipality_id)
  end

  def create_account
    return if account_params.blank? || municipality.blank?

    data_provider = prepared_data_provider
    user = prepared_user

    user.data_provider = data_provider
    return unless user.save!

    user.data_provider
  end

  private

    attr_reader :account_params, :municipality

    def prepared_data_provider
      DataProvider.create(
        name: account_params[:provider_name],
        description: account_params[:description],
        logo: create_web_url(logo_url),
        roles: account_params[:data_provider_roles],
        municipality: municipality,
        data_type: account_params[:data_type]
      )
    end

    def prepared_user
      user_password = SecureRandom.alphanumeric

      User.create(
        email: account_params[:email],
        password: user_password,
        password_confirmation: user_password,
        role: account_params[:role],
        municipality: municipality
      )
    end

    def create_web_url(logo_url)
      logo_url = "https://smart-village.solutions/wp-content/uploads/2020/09/Logo-Smart-Village-Solutions-SVS.png" if logo_url.blank?
      WebUrl.create(url: logo_url)
    end
end
