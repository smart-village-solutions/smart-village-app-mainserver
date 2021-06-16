class Survey::Poll < ApplicationRecord
  has_one :date, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_many :questions, class_name: "Survey::Question", foreign_key: "survey_poll_id", dependent: :destroy

  store :title, coder: JSON
  store :description, coder: JSON

  accepts_nested_attributes_for :date, :questions
end
