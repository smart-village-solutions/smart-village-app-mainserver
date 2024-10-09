# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: categories
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  tmb_id          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ancestry        :string(255)
#  municipality_id :integer
#  icon_name       :string(255)
#  payload         :text(65535)
#  active          :boolean          default(TRUE)
#
