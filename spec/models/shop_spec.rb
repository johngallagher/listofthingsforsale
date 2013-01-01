# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Shop" do
  it "should have default currency as dollars" do
    shop = Shop.new()
    assert_equal(shop.currency, Currency::USD)
  end
  it "should detect currency on new" do
    shop = Shop.create(:description => "name £3.00 description", :url => "matthias_")
    assert_equal(shop.currency, Currency::GBP)
  end
end