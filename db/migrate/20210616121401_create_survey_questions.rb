class CreateSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_questions do |t|
      t.integer :survey_poll_id
      t.longtext :title

      t.timestamps
    end
  end
end
