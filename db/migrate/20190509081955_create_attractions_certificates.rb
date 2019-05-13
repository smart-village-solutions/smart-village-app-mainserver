class CreateAttractionsCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :attractions_certificates do |t|
      t.belongs_to :attraction, index: true
      t.belongs_to :certificate, index: true
    end
  end
end
