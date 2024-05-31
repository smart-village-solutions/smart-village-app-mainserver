# frozen_string_literal: true

class Api::V1::AccountsController < Api::BaseController
  before_action :set_data_provider, only: %i[show update]
  before_action :authenticate_user_role, only: %i[show update]

  USER_PARAMS = %i[
    email
    role
  ].freeze

  DATA_PROVIDER_PARAMS = %i[
    name
    description
    notice
    data_type
    logo_url
    logo_description
    addition
    city
    street
    zip
    contact_first_name
    contact_last_name
    contact_phone
    contact_fax
    contact_email
  ].freeze

  EXTERNAL_SERVICE_PARAMS = %i[
    external_service_id
    client_key
    client_secret
  ] + [{
    external_service_additional_params: []
  }]

  PARAMS = USER_PARAMS + DATA_PROVIDER_PARAMS + EXTERNAL_SERVICE_PARAMS
  INDIVIDUAL_ACCOUNT_PARAMS = DATA_PROVIDER_PARAMS + EXTERNAL_SERVICE_PARAMS

  def show
    render_account_response(@data_provider)
  end

  def create
    account = Accounts::CreateAccountService.new(
      account_params: account_params,
      municipality_id: MunicipalityService.municipality_id
    ).create_account

    render_account_response(account, :created)
  end

  def update
    detected_params = management_user_role? ? account_params : individual_account_params

    if detected_params[:external_service_additional_params] && detected_params[:external_service_id].blank?
      render json: {
        error: "external_service_id is required when external_service_additional_params is provided."
      }, status: :unprocessable_entity
      return
    end

    account = Accounts::UpdateAccountService.new(
      data_provider_id: @data_provider.id,
      account_params: account_params
    ).update_account

    render_account_response(account)
  end

  private

    def authenticate_user_role
      render_unauthorized unless management_user_role? || user_allowed_to_update?
    end

    def management_user_role?
      current_user&.account_manager_role? || current_user&.admin_role?
    end

    def user_allowed_to_update?
      current_user&.data_provider&.id == @data_provider&.id
    end

    def individual_account_params
      account_params.slice(*(DATA_PROVIDER_PARAMS + EXTERNAL_SERVICE_PARAMS))
    end

    def account_params
      permitted_params = PARAMS.dup

      # Dynamically fetch and permit all keys for `external_service_additional_params` if present
      if params[:account][:external_service_additional_params].present?
        permitted_params += [{
          external_service_additional_params: params[:account][:external_service_additional_params].keys.map(&:to_sym)
        }]
      end
      params.require(:account).permit(*permitted_params)
    end

    def set_data_provider
      @data_provider = DataProvider.find_by(id: params[:id])
      render_not_found unless @data_provider
    end

    def render_account_response(account, status = :ok)
      if account
        render json: { account: serialize_account(account) }, status: status
      else
        render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def serialize_account(account)
      account.as_json(include: {
        external_service: { only: %i[id name] },
        user: {
          only: %i[email role],
          include: {
            oauth_applications: {
              only: %i[uid secret]
            }
          }
        },
        logo: { only: %i[url description] },
        address: { only: %i[addition street city zip] },
        contact: { only: %i[first_name last_name phone fax email] }
      }, only: %i[id name description notice data_type roles])
    end
end
