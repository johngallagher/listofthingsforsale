require 'test_helper'

class OrderValidatorTest < ActiveSupport::TestCase
  # identical orders except for number of items
  test "if number of items in cart is different should be invalid" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
  
    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    params_order.merge!({"num_cart_items" => "3"})
  
    
    orders_match = OrderComparer.new(:params_order => params_order, :pending_order => pending_order).orders_match?
  
    assert !orders_match
  end
end