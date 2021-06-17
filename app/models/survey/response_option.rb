# frozen_string_literal: true

class Survey::ResponseOption < ApplicationRecord
  belongs_to :question, class_name: "Survey::Question", optional: true, foreign_key: "survey_question_id"

  store :title, coder: JSON

  before_destroy :any_votes_present?, prepend: true do
    throw(:abort) if errors.present?
  end

  private

    def any_votes_present?
      errors.add(:votes_count, "Cannot delete ResponseOption with votes") if votes_count.positive?
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
