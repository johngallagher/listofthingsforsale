require "test_helper"

class TestItemFinder < Test::Unit::TestCase
  # Partial matches
  test "given two name and price matches should return item with the nearest description" do
    wallet_1 = Factory.build(:wallet_item)
    wallet_2 = Factory.build(:wallet_item)
    wallet_1.description_text = "this is a gorgeous wallet"
    wallet_2.description_text = "brand new"
    
    found_item = ItemFinder.new(:existing_items => [wallet_1, wallet_2], :line_hash => {:name => wallet_1.name, :price => wallet_1.price, :description_text => "brand spanking new"}).find_partial_match
    assert_equal(wallet_2, found_item)
  end
end