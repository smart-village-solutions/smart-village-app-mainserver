require 'rails_helper'

RSpec.describe Report, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  reportable_type :string(255)      not null
#  reportable_id   :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
