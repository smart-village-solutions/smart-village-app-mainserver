# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticContent, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:data_type) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end

# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
