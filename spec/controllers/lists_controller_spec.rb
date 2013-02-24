require 'spec_helper'

describe ListsController do
  describe "GET new" do
    before do
      get :new
    end

    it "renders the new template" do
      response.should render_template :new
    end

    it "assigns a list" do
      assigns[:list].should be_present
    end
  end

  describe "POST create" do
    let(:valid_attributes) { { :list => { products_text: "This is my list" } } }

    before do
      post :create, valid_attributes
    end

    it "redirects to lists" do
      response.should redirect_to(list_path(assigns[:list]))
    end
  end

  describe "when a list exists" do    

    describe "GET show" do
      let(:list) { FactoryGirl.create :list }
      let(:valid_attributes) { {:id => list.to_param} }

      before do
        get :show, valid_attributes
      end

      it "renders the show template" do
        response.should render_template :show      
      end

      it "assigns a list" do
        assigns[:list].should be_present
      end
    end

    describe "GET edit" do
      let(:list) { FactoryGirl.create :list }
      let(:valid_attributes) { {:id => list.to_param} }

      before do
        list.save!
        get :edit, valid_attributes
      end

      it "renders the edit template" do
        response.should render_template :edit      
      end

      it "assigns a list" do
        assigns[:list].should be_present
      end
    end

    describe "PUT update" do
      let(:list) { FactoryGirl.create :list }
      let(:valid_attributes) { {:id => list.to_param, :list => { :products_text => "Updated list" } } }

      before do
        list.save!
        put :update, valid_attributes
      end

      it "redirects to list" do
        response.should redirect_to list
      end
    end
  end
end