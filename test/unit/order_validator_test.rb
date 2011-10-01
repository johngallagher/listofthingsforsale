require 'test_helper'

class OrderFinderTest < ActiveSupport::TestCase
  # identical orders except for number of items
  test "if number of items in cart is different should return nil" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
  
    params_order = params_from_pending_order(pending_order)
    params_order.merge!({"num_cart_items" => "3"})
  
    order_found = OrderFinder.new(:params_order => params_order).find_pending
  
    assert_nil(order_found)
  end
end