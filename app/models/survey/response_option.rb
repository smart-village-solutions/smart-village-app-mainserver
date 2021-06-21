# frozen_string_literal: true

class Survey::ResponseOption < ApplicationRecord
  belongs_to :question, class_name: "Survey::Question", optional: true, foreign_key: "survey_question_id"

  store :title, coder: JSON

  after_update :destroy_empty_response

  private

    # after saving response options we want to delete the ones without titles and votes
    # SVA2-5
    def destroy_empty_response
      destroy if !title.values.map(&:present?).include?(true) && votes_count.zero?
    end
end

# == Schema Information
#
# Table name: survey_response_options
#
#  id                 :bigint           not null, primary key
#  survey_question_id :integer
#  title              :text(4294967295)
#  votes_count        :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
