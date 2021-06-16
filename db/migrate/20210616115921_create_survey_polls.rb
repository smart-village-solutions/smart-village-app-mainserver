class CreateSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_polls do |t|
      t.longtext :title
      t.longtext :description

      t.timestamps
    end
  end
end
