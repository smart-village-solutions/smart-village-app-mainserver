# frozen_string_literal: true

class Accounts::CreateAccountService
  include Accounts::RoleValidatorMixin
  include WebUrlCreationMixin

  DEFAULT_ROLES = {
    role_point_of_interest: true,
    role_tour: true,
    role_news_item: true,
    role_event_record: true,
    role_voucher: true,
    role_noticeboard: true,
    role_encounter_support: true,
    role_survey: true,
    role_offer: true,
    role_job: true,
    role_push_notification: false,
    role_lunch: false,
    role_waste_calendar: false,
    role_construction_site: false,
    role_static_contents: false,
    role_tour_stops: false,
    role_deadlines: false,
    role_defect_report: false
  }.freeze

  def initialize(account_params: {}, municipality_id: nil)
    @account_params = account_params
    @municipality_id = municipality_id || MunicipalityService.municipality_id
  end

  def create_account
    validate_role(account_params[:role])

    ActiveRecord::Base.transaction do
      user = create_user
      data_provider = create_data_provider
      user.data_provider = data_provider
      user.save!
      create_oauth_application!(user)
      data_provider
    end
  end

  private

    attr_reader :account_params, :municipality_id

    def create_user
      user_password = SecureRandom.alphanumeric

      User.create!(
        email: account_params[:email],
        password: user_password,
        password_confirmation: user_password,
        role: account_params[:role],
        municipality_id: municipality_id
      )
    end

    def create_oauth_application!(user)
      user.oauth_applications.create(
        name: "Zugriff per CMS",
        redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
        confidential: true
      )
    end

    def create_data_provider
      DataProvider.create!(
        name: account_params[:name],
        description: account_params[:description],
        notice: account_params[:notice],
        data_type: account_params[:data_type] || :business_account,
        logo: create_web_url(account_params[:logo_url], account_params[:logo_description]),
        address: create_address,
        contact: create_contact,
        **DEFAULT_ROLES
      )
    end

    def create_address
      Address.create(
        addition: account_params[:addition],
        city: account_params[:city],
        street: account_params[:street],
        zip: account_params[:zip]
      )
    end

    def create_contact
      Contact.create(
        first_name: account_params[:contact_first_name],
        last_name: account_params[:contact_last_name],
        phone: account_params[:contact_phone],
        fax: account_params[:contact_fax],
        email: account_params[:contact_email]
      )
    end
end
