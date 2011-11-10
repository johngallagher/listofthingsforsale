require 'spec_helper'

describe "Item" do
  it "items should be equal if name, description, price, quantity are all equal" do
    wallet_1 = Factory.build(:wallet_item)
    wallet_2 = Factory.build(:wallet_item)
    assert(wallet_1.equal_to_item?(wallet_2), "Not equal")
  end
end