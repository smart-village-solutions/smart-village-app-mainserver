class AddVersionToStaticContents < ActiveRecord::Migration[5.2]
  def change
    add_column :static_contents, :version, :string
  end
end
