# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :trackable, :omniauthable and :rememberable
  devise :database_authenticatable, :recoverable, :validatable, :lockable, :timeoutable, :token_authenticatable
  enum role: { user: 0, admin: 1, app: 2, restricted: 3, editor: 4, read_only: 5, extended_user: 6 }, _suffix: :role

  include Sortable
  include MunicipalityScope

  sortable_on :email, :id

  include Searchable
  searchable_on :email

  validates_presence_of :email
  validates_uniqueness_of :email, scope: :municipality_id

  belongs_to :data_provider, optional: true
  belongs_to :municipality
  accepts_nested_attributes_for :data_provider

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :oauth_applications,
           class_name: "Doorkeeper::Application",
           as: :owner

  # Diese Methode kommt von Devise und muss überschrieben werden, damit
  # der eigene "validates_uniqueness_of :email" ausgeführt wird.
  def will_save_change_to_email?
    false
  end

  # Diese Methode muss kommt von Devise und muss überschrieben werden, damit
  # der eigene "validates_uniqueness_of :email" ausgeführt wird.
  def email_changed?
    false
  end

  # Diese Methode wird von Devise verwendet um einen User in der Datenbank zu finden
  # und wird hiermit überschrieben mit einem Filter auf eine Kommune.
  #
  # @param [Hash] warden_conditions {:email=>"admin@smart-village.app", :subdomain=>"bad-belzig.server"}
  #
  # @return [Scope] User.where...
  def self.find_for_authentication(warden_conditions) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    subdomains = Array(warden_conditions.fetch(:subdomain, "").to_s.try(:split, "."))

    municipality_service = MunicipalityService.new(subdomains: subdomains)
    @current_municipality = municipality_service.municipality if municipality_service.subdomain_valid?
    MunicipalityService.municipality_id = @current_municipality.id if @current_municipality.present?

    if @current_municipality.present?
      # params = { municipality_id: @current_municipality.id }
      params = warden_conditions[:email].present? ? { email: warden_conditions[:email] } : {}
      if warden_conditions[:authentication_token].present?
        params.merge!(authentication_token: warden_conditions[:authentication_token])
      end

      return where(params).first
    end

    where("1 == 0")
  end
end

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  email                           :string(255)      default(""), not null
#  encrypted_password              :string(255)      default(""), not null
#  reset_password_token            :string(255)
#  reset_password_sent_at          :datetime
#  remember_created_at             :datetime
#  sign_in_count                   :integer          default(0), not null
#  current_sign_in_at              :datetime
#  last_sign_in_at                 :datetime
#  current_sign_in_ip              :string(255)
#  last_sign_in_ip                 :string(255)
#  confirmation_token              :string(255)
#  confirmed_at                    :datetime
#  confirmation_sent_at            :datetime
#  unconfirmed_email               :string(255)
#  failed_attempts                 :integer          default(0), not null
#  unlock_token                    :string(255)
#  locked_at                       :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  data_provider_id                :integer
#  role                            :integer          default("user")
#  authentication_token            :text(65535)
#  authentication_token_created_at :datetime
#  municipality_id                 :integer
#
