FactoryBot.define do
  factory :media_content do
    caption_text { "MyString" }
    copyright { "MyString" }
    height { "MyString" }
    width { "MyString" }
    link { "MyString" }
    type { "" }
    source_url { "MyString" }
  end
end

# == Schema Information
#
# Table name: media_contents
#
#  id            :bigint(8)        not null, primary key
#  caption_text  :string(255)
#  copyright     :string(255)
#  height        :string(255)
#  width         :string(255)
#  type          :string(255)
#  mediable_type :string(255)
#  mediable_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
