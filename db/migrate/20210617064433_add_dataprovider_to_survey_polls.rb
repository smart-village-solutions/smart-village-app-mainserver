class AddDataproviderToSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_polls, :data_provider_id, :integer
  end
end
