require 'rails_helper'

RSpec.describe "StaticContents", type: :request do
  describe "GET /static_contents" do
    it "works! (now write some real specs)" do
      get static_contents_path
      expect(response).to have_http_status(200)
    end
  end
end
