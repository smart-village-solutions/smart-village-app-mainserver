FactoryBot.define do
  factory :web_url do
    url { "MyString" }
    description { "MyString" }
  end
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint           not null, primary key
#  url              :string(255)
#  description      :text(65535)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
