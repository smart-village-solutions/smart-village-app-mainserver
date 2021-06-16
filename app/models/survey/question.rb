class Survey::Question < ApplicationRecord
  belongs_to :poll, class_name: "Survey::Poll", optional: true, foreign_key: "survey_poll_id"
  has_many :response_options, class_name: "Survey::ResponseOption", foreign_key: "survey_question_id", dependent: :destroy

  store :title, coder: JSON
end
