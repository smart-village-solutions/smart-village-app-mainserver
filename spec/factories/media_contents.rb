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
#  id             :bigint           not null, primary key
#  caption_text   :text(65535)
#  copyright      :string(255)
#  height         :string(255)
#  width          :string(255)
#  content_type   :string(255)
#  mediaable_type :string(255)
#  mediaable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
