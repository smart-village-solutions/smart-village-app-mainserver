class AddOperatingCompanyToAdress < ActiveRecord::Migration[5.2]
  def change
    add_reference :adresses, :operating_company, index: true
  end
end
