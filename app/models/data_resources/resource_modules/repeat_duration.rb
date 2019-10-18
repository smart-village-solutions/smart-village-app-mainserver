# frozen_string_literal: true

# provides information for how long an event should be repeated.
class RepeatDuration < ApplicationRecord
  belongs_to :event_record
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
