# frozen_string_literal: true

# provides dates to other resources (e.g. Events) who need a fixed dates
class FixedDate < ApplicationRecord
  belongs_to :dateable, polymorphic: true

  # upcoming fixed dates with ignoring the first one if the resource is an recurring event
  scope :upcoming, lambda { |ignore_first = false|
    where_clause = "date_start >= ? OR date_end >= ?"
    return where(where_clause, Date.today, Date.today).where.not(id: first.id) if ignore_first
    where(where_clause, Date.today, Date.today)
  }
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
