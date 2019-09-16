# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebUrl, type: :model do
  it { is_expected.to belong_to(:web_urlable) }
  it { is_expected.to validate_presence_of(:url) }

  describe "#url" do
    it "only accepts valid urls" do
      url = WebUrl.create(url: "test")
      expect(url).to be_invalid
    end
  end
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint           not null, primary key
#  url              :text(65535)
#  description      :text(65535)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
