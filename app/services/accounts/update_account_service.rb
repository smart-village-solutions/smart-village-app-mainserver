# frozen_string_literal: true

class Accounts::UpdateAccountService
  include Accounts::RoleValidatorMixin

  def initialize(data_provider_id:, account_params: {})
    @data_provider_id = data_provider_id
    @account_params = account_params
  end

  def update_account
    validate_role(account_params[:role]) if account_params[:role]

    ActiveRecord::Base.transaction do
      data_provider = DataProvider.find(data_provider_id)
      user = data_provider.user
      user.update!(user_params)
      data_provider.update!(data_provider_params)
      update_related_attributes(data_provider)
      update_external_service(data_provider) if account_params[:external_service_id].present?

      data_provider
    end
  end

  private

    attr_reader :data_provider_id, :account_params

    def user_params
      account_params.slice(:email, :role)
    end

    def data_provider_params
      account_params.slice(
        :name,
        :description,
        :notice,
        :data_type
      )
    end

    def update_external_service(data_provider)
      credential = ExternalServiceCredential.find_or_initialize_by(
        data_provider_id: data_provider.id,
        external_service_id: account_params[:external_service_id]
      )

      credential.client_key = account_params[:client_key] if account_params.key?(:client_key)
      credential.client_secret = account_params[:client_secret] if account_params.key?(:client_secret)
      credential.organization_id = account_params[:organization_id] if account_params.key?(:organization_id)

      credential.save! if credential.new_record? || credential.changed?
    end

    def update_related_attributes(data_provider)
      update_logo(data_provider)
      update_address(data_provider)
      update_contact(data_provider)
    end

    def update_logo(data_provider)
      logo_attributes = {}
      logo_attributes["url"] = account_params[:logo_url] if account_params[:logo_url].present?
      logo_attributes["description"] = account_params[:logo_description] if account_params[:logo_description].present?

      data_provider.logo.update!(logo_attributes)
    end

    def update_address(data_provider)
      address_attributes = account_params.slice(
        :addition,
        :city,
        :street,
        :zip
      )
      data_provider.address.update!(address_attributes)
    end

    def update_contact(data_provider)
      contact_attributes = build_contact_attributes
      data_provider.contact.update!(contact_attributes)
    end

    def build_contact_attributes # rubocop:disable Metrics/AbcSize
      contact_attributes = {}
      contact_attributes["first_name"] = account_params[:contact_first_name] if account_params.key?(:contact_first_name)
      contact_attributes["last_name"] = account_params[:contact_last_name] if account_params.key?(:contact_last_name)
      contact_attributes["phone"] = account_params[:contact_phone] if account_params.key?(:contact_phone)
      contact_attributes["fax"] = account_params[:contact_fax] if account_params.key?(:contact_fax)
      contact_attributes["email"] = account_params[:contact_email] if account_params.key?(:contact_email)
      contact_attributes
    end
end
