class Survey::Poll < ApplicationRecord
  include FilterByRole

  has_one :date, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_many :questions, class_name: "Survey::Question", foreign_key: "survey_poll_id", dependent: :destroy

  belongs_to :data_provider

  store :title, coder: JSON
  store :description, coder: JSON

  accepts_nested_attributes_for :date, :questions
end

# == Schema Information
#
# Table name: survey_polls
#
#  id          :bigint           not null, primary key
#  title       :text(4294967295)
#  description :text(4294967295)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  visible     :boolean          default(TRUE)
#
