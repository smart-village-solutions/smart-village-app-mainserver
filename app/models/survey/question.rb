# frozen_string_literal: true

class Survey::Question < ApplicationRecord
  belongs_to :poll, class_name: "Survey::Poll", optional: true, foreign_key: "survey_poll_id"
  has_many :response_options, class_name: "Survey::ResponseOption", foreign_key: "survey_question_id", dependent: :destroy

  store :title, coder: JSON

  accepts_nested_attributes_for :response_options
end

# == Schema Information
#
# Table name: survey_questions
#
#  id                       :bigint           not null, primary key
#  survey_poll_id           :integer
#  title                    :text(4294967295)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  allow_multiple_responses :boolean          default(FALSE)
#
