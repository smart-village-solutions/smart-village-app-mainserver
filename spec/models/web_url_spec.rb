require 'rails_helper'

RSpec.describe WebUrl, type: :model do
  it { should belong_to(:web_urlable) }

  describe "#url" do
    it "only accepts valid urls" do
      url = WebUrl.create(url: "test")
      expect(url).to be_valid
    end
  end
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint(8)        not null, primary key
#  url              :string(255)
#  description      :string(255)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
