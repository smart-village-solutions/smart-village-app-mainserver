class ChangeCaptionTextToBeTextInMediaContents < ActiveRecord::Migration[5.2]
  def change
    change_column :media_contents, :caption_text, :text
  end
end
