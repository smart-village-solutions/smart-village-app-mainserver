class AddAllowMultipleResponsesToSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_questions, :allow_multiple_responses, :boolean, default: false
  end
end
