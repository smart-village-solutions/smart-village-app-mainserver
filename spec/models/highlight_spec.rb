require 'rails_helper'

RSpec.describe Highlight, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: highlights
#
#  id                 :bigint           not null, primary key
#  event              :boolean
#  holiday            :boolean
#  local              :boolean
#  monthly            :boolean
#  regional           :boolean
#  highlightable_type :string(255)
#  highlightable_id   :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
