FactoryBot.define do
  factory :static_content do
    name { "MyString" }
    data_type { "MyString" }
    content { "MyText" }
  end
end

# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :string(255)
#
