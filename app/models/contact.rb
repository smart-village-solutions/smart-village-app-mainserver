# frozen_string_literal: true

class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  has_one :web_url, as: :web_urlable

  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "Only valid emails allowed"
  },
                    unless: proc { |record| record.email.blank? }
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
