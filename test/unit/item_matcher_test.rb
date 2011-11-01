require 'test_helper'
class ItemMatcherTest < ActiveSupport::TestCase
  # with one item
  test "item with same name, price and description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :description_text => "this is a gorgeous wallet", :price => 22.22}).match
    assert_equal(wallet, found_item)
  end
  test "item with same name, different price and description should not match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :description_text => "this is a wallet", :price => 12.22}).match
    assert_nil(found_item)
  end
end
