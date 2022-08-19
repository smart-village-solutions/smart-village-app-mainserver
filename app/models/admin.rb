class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

  # Diese Methode wird von Devise verwendet um einen User in der Datenbank zu finden
  # und wird hiermit überschrieben mit einem Filter auf eine Kommune.
  #
  # @param [Hash] warden_conditions {:email=>"admin@smart-village.app", :subdomain=>"bad-belzig.server"}
  #
  # @return [Scope] User.where...
  def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email]).first
  end
end
