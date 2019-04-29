require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should belong_to(:contactable) }
  it { should have_one(:web_url) }
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
