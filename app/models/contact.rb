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
#  url              :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Contact < ApplicationRecord
    belongs_to :contactable, polymorphic: true
    has_one :web_url, as: :web_urlable
end
