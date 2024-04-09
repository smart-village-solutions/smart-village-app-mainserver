FactoryBot.define do
  factory :data_provider do
    name { "MyString" }
    description { "MyString" }
    municipality_id { 1 }

    trait :with_logo do
      logo { create(:web_url, :for_data_provider) }
    end

    trait :with_address do
      address { create(:address, :for_data_provider) }
    end

    trait :with_contact do
      contact { create(:contact, :for_data_provider) }
    end
  end
end

# == Schema Information
#
# Table name: data_providers
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  description     :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  always_recreate :text(65535)
#  roles           :text(65535)
#  data_type       :integer          default("general_importer")
#  notice          :text(65535)
#  import_feeds    :text(16777215)
#
