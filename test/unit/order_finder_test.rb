require 'test_helper'

class OrderFinderTest < ActiveSupport::TestCase
  
  test "if nil order params should raise" do
    assert_raise(RuntimeError) { OrderFinder.new(:params_order => nil).find_pending }
  end
  
  test "if order params are present with no entries in database should return nil" do
    pending_order = Factory.build(:johns_pending_order_for_bag_and_wallet)

    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    assert_nil(order_found)
  end
  
  test "if order params match pending order in database should return that order" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)

    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  test "with two similar orders should return the correct order" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
    similar_pending_order =  Factory(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop) #has the same no of items and total price
    
    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  test "similar orders with less line items in param order than in pending order should return nil" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop)

    template_order = Factory.build(:johns_pending_order_for_jacket, :shop => matthias_shop)
    params_order = PaypalParamsGenerator.new(:order => template_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_nil(order_found)
  end

  
end
