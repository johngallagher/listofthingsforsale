require 'test_helper'
class ItemMatcherTest < ActiveSupport::TestCase
  # with one item
  test "item with same name, price and description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :price => 22.22, :description_text => "this is a gorgeous wallet"}).match
    assert_equal(wallet, found_item)
  end
  test "item with same name, different price and description should not match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :price => 12.22, :description_text => "this is a wallet"}).match
    assert_nil(found_item)
  end
  test "item with different description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :price => 22.22, :description_text => "this is a wallet"}).match
    assert_equal(wallet, found_item)
  end
  test "item with different price should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "wallet", :price => 12.22, :description_text => "this is a gorgeous wallet"}).match
    assert_equal(wallet, found_item)
  end
  test "item with different name should match" do
    wallet = Factory.build(:wallet_item)
    found_item = ItemMatcher.new(:items => [wallet], :criteria => {:name => "nice wallet", :price => 22.22, :description_text => "this is a gorgeous wallet"}).match
    assert_equal(wallet, found_item)
  end
end
