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

    # make sure the factory has set it all up right.
    assert @order.shop_id != 0
    assert @order.status == Status::Pending
    assert !@order.session_id.empty?
    assert !@order.session_id.blank?
    assert !@order.session_id.nil?
    assert @order.total_price != 0
  end
  
  test "should create order with same shop id" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    assert adapted_order.shop_id == @order.shop_id
  end
  
  test "should create order with same status if pending" do
    @order.status = Status::Pending
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    
    assert adapted_order.status == @order.status
    assert adapted_order.status == Status::Pending
  end
  
  test "should create order with same status if completed" do
    @order.status = Status::Completed
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    
    assert adapted_order.status == @order.status
    assert adapted_order.status == Status::Completed
  end

  test "should create order with same session id" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    assert adapted_order.session_id == @order.session_id
  end
  
  test "should create order with same total price" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    assert adapted_order.total_price == @order.total_price
  end
end