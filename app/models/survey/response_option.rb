class Survey::ResponseOption < ApplicationRecord
  belongs_to :question, class_name: "Survey::Question", optional: true, foreign_key: "survey_question_id"

  store :title, coder: JSON
end
