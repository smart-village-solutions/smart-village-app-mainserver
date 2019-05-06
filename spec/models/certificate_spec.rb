# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificate, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  attraction_id :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
