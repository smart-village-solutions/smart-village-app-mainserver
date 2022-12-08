# frozen_string_literal: true

FactoryBot.define do
  factory :generic_item do
    id { 1 }
    generic_type { "RandomType" }
    title { "MyString" }
    description { "MyText" }
    data_provider_id { 1 }
  end
end

# == Schema Information
#
# Table name: generic_items
#
#  id               :bigint           not null, primary key
#  generic_type     :string(255)
#  author           :text(65535)
#  publication_date :datetime
#  published_at     :datetime
#  external_id      :text(65535)
#  visible          :boolean          default(TRUE)
#  title            :text(65535)
#  teaser           :text(65535)
#  description      :text(65535)
#  data_provider_id :integer
#  payload          :text(65535)
#  ancestry         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
