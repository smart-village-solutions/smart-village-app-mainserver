# frozen_string_literal: true

class Api::V1::AccountsController < Api::BaseController
  before_action :set_data_provider, only: %i[show update destroy]

  USER_PARAMS = %i[
    email
    role
  ].freeze

  DATA_PROVIDER_PARAMS = %i[
    name
    description
    notice
    data_type
    roles
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

  PARAMS = USER_PARAMS + DATA_PROVIDER_PARAMS + [{ roles: {} }]

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
    account = Accounts::UpdateAccountService.new(
      data_provider_id: @data_provider.id,
      account_params: account_params
    ).update_account

    render_account_response(account)
  end

  def destroy
    account = Accounts::DestroyAccountService.new(data_provider_id: @data_provider.id).destroy_account
    render_account_response(account, :no_content)
  end

  private

    def account_params
      params.require(:account).permit(*PARAMS)
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
        user: { only: %i[email role] },
        logo: { only: %i[url description] },
        address: { only: %i[addition street city zip] },
        contact: { only: %i[first_name last_name phone fax email] }
      }, only: %i[id name description notice data_type roles])
    end
end
