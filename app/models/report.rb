# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
end

# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  reportable_type :string(255)      not null
#  reportable_id   :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
