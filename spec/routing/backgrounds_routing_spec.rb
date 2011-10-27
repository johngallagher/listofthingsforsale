require "spec_helper"

describe BackgroundsController do
  describe "routing" do

    it "routes to #index" do
      get("/backgrounds").should route_to("backgrounds#index")
    end

    it "routes to #new" do
      get("/backgrounds/new").should route_to("backgrounds#new")
    end

    it "routes to #show" do
      get("/backgrounds/1").should route_to("backgrounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/backgrounds/1/edit").should route_to("backgrounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/backgrounds").should route_to("backgrounds#create")
    end

    it "routes to #update" do
      put("/backgrounds/1").should route_to("backgrounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/backgrounds/1").should route_to("backgrounds#destroy", :id => "1")
    end

  end
end
