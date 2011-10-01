require 'test_helper'

=begin

order attributes to generate

shop
shop_id
status
session_id
total_price
currency

line items to generate

for each li:

item
item id
name
quantity
unit price

=end
class PaypalParamsToOrderAdapterTest < ActiveSupport::TestCase
  test "should create order with same shop id" do
    order = Factory.build(:johns_pending_order_for_bag_and_wallet_from_matthias_shop)
    
    paypal_params = PaypalParamsGenerator.new(:order => order).generate_params
    
    assert order.shop_id == PaypalParamsToOrderAdapter.new(paypal_params).shop_id
  end
end