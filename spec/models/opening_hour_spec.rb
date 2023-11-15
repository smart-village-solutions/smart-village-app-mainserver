# frozen_string_literal: true

require "rails_helper"

RSpec.describe OpeningHour, type: :model do
  it { is_expected.to belong_to(:openingable) }
end

# == Schema Information
#
# Table name: opening_hours
#
#  id               :bigint           not null, primary key
#  weekday          :string(255)
#  date_from        :date
#  date_to          :date
#  time_from        :time
#  time_to          :time
#  sort_number      :integer
#  open             :boolean
#  description      :text(65535)
#  openingable_type :string(255)
#  openingable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  use_year         :boolean
#
