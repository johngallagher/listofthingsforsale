require 'test_helper'
class ItemMatcherTest < ActiveSupport::TestCase
  test "one item with same name, price and description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :description_text => "this is a gorgeous wallet", :price => 22.22}).match
    assert_equal(wallet, found_item)
  end
end
