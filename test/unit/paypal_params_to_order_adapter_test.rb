require 'test_helper'

=begin

order attributes to generate

shop_id
status
session_id
total_price
currency

line items to generate

for each li:

item id
name
quantity
unit price

=end
class PaypalParamsToOrderAdapterTest < ActiveSupport::TestCase
  setup do
    @matthias_shop = Factory(:matthias_shop)
    @order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => @matthias_shop)
  end
  
  test "should create order with same shop id" do
    # puts "order is #{@order.inspect} with line items #{@order.line_items.inspect} and shop #{@order.shop}"
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    # puts "paypal params are #{paypal_params}"
    
    adapted_shop = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    
    assert @order.shop_id != 0
    assert adapted_shop.shop_id == @order.shop_id
  end
  
  # test "should create order with same status" do
  #   paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
  #   
  #   assert PaypalParamsToOrderAdapter.new(paypal_params).adapt.status == Status::Pending
  # end
  # 
  # test "should create order with same session id" do
  #   paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
  # 
  #   assert order.session_id != ""
  #   assert_not_nil order.session_id
  #   
  #   assert PaypalParamsToOrderAdapter.new(paypal_params).adapt.status == order.session_id
  # end

end