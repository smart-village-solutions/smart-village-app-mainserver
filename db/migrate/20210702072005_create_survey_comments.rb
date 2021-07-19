class CreateSurveyComments < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_comments do |t|
      t.integer :survey_poll_id
      t.text :message
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
