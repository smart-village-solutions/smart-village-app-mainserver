class AddVisibleToSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_polls, :visible, :boolean, default: true
  end
end
