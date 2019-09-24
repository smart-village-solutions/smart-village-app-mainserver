require "rails_helper"

RSpec.describe StaticContentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/static_contents").to route_to("static_contents#index")
    end

    it "routes to #new" do
      expect(:get => "/static_contents/new").to route_to("static_contents#new")
    end

    it "routes to #show" do
      expect(:get => "/static_contents/1").to route_to("static_contents#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/static_contents/1/edit").to route_to("static_contents#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/static_contents").to route_to("static_contents#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/static_contents/1").to route_to("static_contents#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/static_contents/1").to route_to("static_contents#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/static_contents/1").to route_to("static_contents#destroy", :id => "1")
    end
  end
end
