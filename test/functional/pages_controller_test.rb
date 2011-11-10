require 'test_helper'

describe "PagesController", ActionController::TestCase do
  it "should get home" do
    get :home
    assert_response :success
  end

  it "should get pricing" do
    get :pricing
    assert_response :success
  end

  it "should get contact" do
    get :contact
    assert_response :success
  end

  it "should get help" do
    get :help
    assert_response :success
  end

end
