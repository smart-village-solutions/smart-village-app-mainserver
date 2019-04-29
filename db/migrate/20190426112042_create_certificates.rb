class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :name
      t.references :point_of_interest, index: true
      t.timestamps
    end
  end
end
