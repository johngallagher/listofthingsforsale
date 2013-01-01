require 'spec_helper'

describe "CategoryNameSanitizer" do
  it "should replace space with hyphen" do
    assert_equal("on-sale", CategoryNameSanitizer.new("on sale").sanitize)
  end
  it "should remove other chars" do
    assert_equal("onsale", CategoryNameSanitizer.new("onsale;,.").sanitize)
  end
  it "should downcase" do
    assert_equal("home-furnishings", CategoryNameSanitizer.new("Home furnishings").sanitize)
  end
end