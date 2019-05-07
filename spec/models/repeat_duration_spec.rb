# frozen_string_literal: true

require "rails_helper"

RSpec.describe RepeatDuration, type: :model do
  it { is_expected.to belong_to(:event_record) }
end

# == Schema Information
#
# Table name: repeat_durations
#
#  id              :bigint           not null, primary key
#  start_date      :date
#  end_date        :date
#  every_year      :boolean
#  event_record_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
