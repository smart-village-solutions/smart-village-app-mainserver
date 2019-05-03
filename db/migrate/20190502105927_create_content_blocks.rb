class CreateContentBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :content_blocks do |t|
      t.string :title
      t.string :intro
      t.text :body
      t.references :content_blockable, polymorphic: true, index: { name: :index_content_blocks_on_content_blockable_type_and_id }

      t.timestamps
    end
  end
end
