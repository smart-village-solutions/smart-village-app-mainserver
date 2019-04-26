class CreateOperatingCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :operating_companies do |t|
      t.string :name
      t.references :companyable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
