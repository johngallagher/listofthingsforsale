require 'spec_helper'

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
describe "PaypalParamsToOrderAdapter", ActiveSupport::TestCase do
  setup do
    @matthias_shop = Factory(:matthias_shop)
    @order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => @matthias_shop)

    # make sure the factory has set it all up right.
    @order.shop_id.should_not ==   nil
    @order.status.should == Status::Pending
    @order.session_id.empty?.should_not ==   true
    @order.session_id.blank?.should_not ==   true
    @order.session_id.nil?.should_not ==   true
    @order.total_price.should_not ==   nil
  end
  
  it "should create order with same shop id" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    adapted_order.shop_id.should == @order.shop_id
  end
  
  it "should create order with same status if pending" do
    @order.status = Status::Pending
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    
    adapted_order.status.should == @order.status
    adapted_order.status.should == Status::Pending
  end
  
  it "should create order with same status if completed" do
    @order.status = Status::Completed
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    
    adapted_order.status.should == @order.status
    adapted_order.status.should == Status::Completed
  end

  it "should create order with same session id" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    adapted_order.session_id.should == @order.session_id
  end
  
  it "should create order with same total price" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    adapted_order.total_price.should == @order.total_price
  end
  
  it "should create order with same currency" do
    paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
    adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
    adapted_order.currency.should == @order.currency
  end
  
  # Later, John.
  # test "should create correct number of line items" do
  #   paypal_params = PaypalParamsGenerator.new(:order => @order).generate_params
  #   adapted_order = PaypalParamsToOrderAdapter.new(paypal_params).adapt
  #   puts "#{adapted_order.line_items.count}"
  #   assert adapted_order.line_items.count == @order.line_items.count
  # end
  
end