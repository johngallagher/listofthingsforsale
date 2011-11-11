require "spec_helper"

describe "ItemFinder" do
  # Partial matches
  it "given two name and price matches should return item with the nearest description" do
    wallet_1 = Factory.build(:wallet_item)
    wallet_2 = Factory.build(:wallet_item)
    wallet_1.description_text = "this is a gorgeous wallet"
    wallet_2.description_text = "brand new"
    
    found_item = ItemFinder.new(:existing_items => [wallet_1, wallet_2], :line_hash => {:name => wallet_1.name, :price => wallet_1.price, :description_text => "brand spanking new"}, :partial => true).find_match
    assert_equal(wallet_2, found_item)
  end
  it "given two name and description matches should return item with nearest price" do
    wallet_1 = Factory.build(:wallet_item)
    wallet_2 = Factory.build(:wallet_item)
    wallet_1.price = 11.11
    wallet_2.price = 22.22
    
    found_item = ItemFinder.new(:existing_items => [wallet_1, wallet_2], :line_hash => {:name => wallet_2.name, :price => 22.23, :description_text => wallet_2.description_text}, :partial => true).find_match
    assert_equal(wallet_2, found_item)
  end
  it "given two description and price matches should return item with the nearest price" do
    wallet_1 = Factory.build(:wallet_item)
    wallet_2 = Factory.build(:wallet_item)
    wallet_1.name = "wallet"
    wallet_2.name = "dolcer and gammana wallet"
    
    found_item = ItemFinder.new(:existing_items => [wallet_1, wallet_2], :line_hash => {:name => "dolce and gabbana wallet", :price => wallet_2.price, :description_text => wallet_2.description_text}, :partial => true).find_match
    assert_equal(wallet_2, found_item)
  end
end