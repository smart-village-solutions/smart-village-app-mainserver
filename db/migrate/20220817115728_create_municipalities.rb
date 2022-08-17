class CreateMunicipalities < ActiveRecord::Migration[6.0]
  def change
    create_table :municipalities do |t|
      t.string :slug
      t.string :title
      t.text :settings

      t.timestamps
    end
  end
end
