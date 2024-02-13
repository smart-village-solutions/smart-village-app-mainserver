# frozen_string_literal: true

class Api::V1::AccountsController < Api::BaseController
  def show
    account = DataProvider.find(params[:id])
    render json: account
  end

  def create
    account = Accounts::CreateAccountService.new(account_params: account_params).create_account
    if account
      render json: account
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def account_params
      params.require(:account).permit(
        :name, :email, :role, :data_type, :logo_link
      )
    end
end
