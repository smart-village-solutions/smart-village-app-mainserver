require 'rails_helper'

RSpec.describe RepeatDuration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: repeat_durations
#
#  id              :bigint           not null, primary key
#  start_date      :date
#  end_date        :date
#  every_year      :boolean
#  updated_at_tmb  :datetime
#  event_record_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
