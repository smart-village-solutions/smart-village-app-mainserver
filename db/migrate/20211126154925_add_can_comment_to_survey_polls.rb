class AddCanCommentToSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_polls, :can_comment, :boolean, default: true
  end
end
