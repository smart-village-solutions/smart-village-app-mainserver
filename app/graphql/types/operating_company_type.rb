module Types
  class OperatingCompanyType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :adress, AdressType, null: true
    field :contact, ContactType, null: true
  end
end