# frozen_string_literal: true

class CreateMediaContents < ActiveRecord::Migration[5.2]
  def change
    create_table :media_contents do |t|
      t.string :caption_text
      t.string :copyright
      t.string :height
      t.string :width
      t.string :content_type
      t.references :mediaable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
