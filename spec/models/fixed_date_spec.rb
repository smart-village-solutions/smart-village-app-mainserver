# frozen_string_literal: true

require "rails_helper"

RSpec.describe FixedDate, type: :model do
  it { is_expected.to belong_to(:dateable) }
end

# == Schema Information
#
# Table name: fixed_dates
#
#  id                        :bigint           not null, primary key
#  date_start                :date
#  date_end                  :date
#  weekday                   :string(255)
#  time_start                :time
#  time_end                  :time
#  time_description          :text(65535)
#  use_only_time_description :boolean          default(FALSE)
#  dateable_type             :string(255)
#  dateable_id               :bigint
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
