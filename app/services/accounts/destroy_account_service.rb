# frozen_string_literal: true

class Accounts::DestroyAccountService
  def initialize(data_provider_id:)
    @data_provider_id = data_provider_id
  end

  def destroy_account
    data_provider = DataProvider.find_by(id: @data_provider_id)
    return unless data_provider

    DataProvider.transaction do
      data_provider.destroy
      data_provider&.user&.destroy
    end

    data_provider
  end
end
