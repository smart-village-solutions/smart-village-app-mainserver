# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :trackable, :omniauthable and :rememberable
  devise :database_authenticatable, :recoverable, :validatable, :lockable, :timeoutable
  has_one :data_provider, as: :provideable

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

  def admin?
    # TODO: Dies muss eine Rechte- und Rollenverwaltung übernehmen
    true
  end
end
