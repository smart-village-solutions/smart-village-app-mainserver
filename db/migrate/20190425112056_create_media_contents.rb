class CreateMediaContents < ActiveRecord::Migration[5.2]
  def change
    create_table :media_contents do |t|
      t.string :caption_text
      t.string :copyright
      t.string :height
      t.string :width
      t.string :link
      t.string :type
      t.string :source_url

      t.timestamps
    end
  end
end
