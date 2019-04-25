class AddOperatingCompanyToContact < ActiveRecord::Migration[5.2]
  def change
    add_reference :contacts, :operating_company, index: true
  end
end
