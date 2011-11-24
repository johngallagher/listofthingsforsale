
require 'spec_helper'

describe "OrderFinder" do
  
  it "if nil order params should raise" do
    assert_raise(RuntimeError) { OrderFinder.new(:params_order => nil).find_pending }
  end
  
  it "if order params are present with no entries in database should return nil" do
    pending_order = Factory.build(:johns_pending_order_for_bag_and_wallet)

    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    assert_nil(order_found)
  end
  
  it "if order params match pending order in database should return that order" do
    matthias_shop = Factory.create(:matthias_shop)
    pending_order = Factory.create(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
    puts "After shop create shop is #{matthias_shop.inspect}"
    puts "After pending order create pending order #{pending_order.inspect}"

    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    puts "\n\n\nAfter Params generate, they are #{params_order}"
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  it "with two similar orders should return the correct order" do
    matthias_shop = Factory.create(:matthias_shop)
    pending_order = Factory.create(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
    similar_pending_order =  Factory.create(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop) #has the same no of items and total price
    
    params_order = PaypalParamsGenerator.new(:order => pending_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  it "similar orders with less line items in param order than in pending order should return nil" do
    matthias_shop = Factory.build(:matthias_shop)
    pending_order = Factory.build(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop)

    template_order = Factory.build(:johns_pending_order_for_jacket, :shop => matthias_shop)
    params_order = PaypalParamsGenerator.new(:order => template_order).generate_params
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_nil(order_found)
  end
end
