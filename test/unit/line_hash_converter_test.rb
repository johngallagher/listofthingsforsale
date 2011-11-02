require 'test_helper'
class LineHashConverterTest < ActiveSupport::TestCase
  # matching existing item
  test "item with same name, price and description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = LineHashConverter.new(:items => [wallet], :line_hash => {:name => "wallet", :price => 22.22, :description_text => "this is a gorgeous wallet"}).convert_to_item
    assert_equal(wallet, found_item)
  end
  test "item with different description should match" do
    wallet = Factory.build(:wallet_item)
    found_item = LineHashConverter.new(:items => [wallet], :line_hash => {:name => "wallet", :price => 22.22, :description_text => "this is a wallet"}).convert_to_item
    assert_equal(wallet, found_item)
  end
  test "item with different price should match" do
    wallet = Factory.build(:wallet_item)
    found_item = LineHashConverter.new(:items => [wallet], :line_hash => {:name => "wallet", :price => 12.22, :description_text => "this is a gorgeous wallet"}).convert_to_item
    assert_equal(wallet, found_item)
  end
  test "item with different name should match" do
    wallet = Factory.build(:wallet_item)
    found_item = LineHashConverter.new(:items => [wallet], :line_hash => {:name => "nice wallet", :price => 22.22, :description_text => "this is a gorgeous wallet"}).convert_to_item
    assert_equal(wallet, found_item)
  end
  # no matching existing item
  test "item with same name, different price and description should create new item" do
    wallet = Factory.build(:wallet_item)
    found_item = LineHashConverter.new(:items => [wallet], :line_hash => {:name => "wallet", :price => 12.22, :description_text => "this is a wallet"}).convert_to_item
    assert_not_nil(found_item)
    assert_not_equal(wallet, found_item)
  end  
end
