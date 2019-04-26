# == Schema Information
#
# Table name: accessibilty_informations
#
#  id              :bigint(8)        not null, primary key
#  description     :string(255)
#  types           :string(255)
#  accessable_type :string(255)
#  accessable_id   :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe AccessibiltyInformation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
