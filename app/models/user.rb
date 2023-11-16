# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :trackable, :omniauthable and :rememberable
  devise :database_authenticatable, :recoverable, :validatable, :lockable, :timeoutable, :token_authenticatable
  enum role: { user: 0, admin: 1, app: 2, restricted: 3, editor: 4, read_only: 5, extended_user: 6 }, _suffix: :role

  include Sortable
  sortable_on :email, :id

  include Searchable
  searchable_on :email

  belongs_to :data_provider, optional: true
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
#
