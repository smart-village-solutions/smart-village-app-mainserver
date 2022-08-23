require "rails_helper"

RSpec.describe MunicipalitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/municipalities").to route_to("municipalities#index")
    end

    it "routes to #new" do
      expect(get: "/municipalities/new").to route_to("municipalities#new")
    end

    it "routes to #show" do
      expect(get: "/municipalities/1").to route_to("municipalities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/municipalities/1/edit").to route_to("municipalities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/municipalities").to route_to("municipalities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/municipalities/1").to route_to("municipalities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/municipalities/1").to route_to("municipalities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/municipalities/1").to route_to("municipalities#destroy", id: "1")
    end
  end
end
