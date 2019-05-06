class Highlight < ApplicationRecord
  belongs_to :highlightable, polymorphic: true
end

# == Schema Information
#
# Table name: highlights
#
#  id                 :bigint           not null, primary key
#  event              :boolean
#  holiday            :boolean
#  local              :boolean
#  monthly            :boolean
#  regional           :boolean
#  highlightable_type :string(255)
#  highlightable_id   :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
