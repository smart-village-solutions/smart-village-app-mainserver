class AddIsMultilingualToSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_polls, :is_multilingual, :boolean, default: false
  end
end
