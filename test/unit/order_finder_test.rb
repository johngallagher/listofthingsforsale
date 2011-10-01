require 'test_helper'

class OrderFinderTest < ActiveSupport::TestCase
  def params_from_pending_order(order)
    params = {  "protection_eligibility"=>"Eligible",
       "address_status"=>"confirmed",
       "tax"=>"0.00",
       "payer_id"=>"MDKEM85G3LMLA",
       "address_street"=>"1 Main Terrace",
       "payment_date"=>"14:17:24 Sep 28, 2011 PDT",
       "charset"=>"windows-1252",
       "address_zip"=>"W12 4LQ",
       "mc_shipping"=>"0.00",
       "mc_handling"=>"0.00",
       "first_name"=>"Test",
       "mc_fee"=>"0.71",
       "address_country_code"=>"GB",
       "address_name"=>"Test User",
       "notify_version"=>"3.2",
       "custom"=>"",
       "payer_status"=>"verified",
       "address_country"=>"United Kingdom",
       "mc_handling1"=>"0.00",
       "address_city"=>"Wolverhampton",
       "verify_sign"=>"ACTQ-IEZ9gMsbO0Pw-mucb3t592GAazwT2TyT4UVXsV9nnRONUdx7DGt",
       "mc_shipping1"=>"0.00",
       "payment_type"=>"instant",
       "last_name"=>"User",
       "address_state"=>"West Midlands",
       "payment_fee"=>"",
       "receiver_id"=>"5EC9ZN6KQH47N",
       "txn_type"=>"cart",
       "mc_currency"=>"GBP",
       "residence_country"=>"GB",
       "test_ipn"=>"1",
       "transaction_subject"=>"Shopping Cart",
       "ipn_track_id"=>"LlEfeRjfHawhnM1zyCcqrA",

       "num_cart_items"=>"#{order.line_items.count}",
       
       "payment_status"=>"Pending",

       #transaction id
       "txn_id"=>"1E232785L98112148",
       
       #total
       "mc_gross"=>"#{order.total_price}",
       "payment_gross"=>"#{order.total_price}",
       
       "session_id"=>"#{order.session_id}" 
    }

    if order.shop and order.shop.user
      emails = { 
        "business"=>"#{order.shop.user.email}",
        "receiver_email"=>"#{order.shop.user.email}",
        "payer_email"=>"" 
        }
    else
      emails = { 
        "business"=>"",
        "receiver_email"=>"",
        "payer_email"=>"" 
        }
    end
    params.merge!(emails)
    
    order.line_items.each_index do |li_index|
      li_index_inc = li_index + 1
      this_item = {
        "option_name1_#{li_index_inc}"=>"shopid",
        "option_selection1_#{li_index_inc}"=>"#{order.shop_id}",

        "option_name2_#{li_index_inc}"=>"itemid",
        "option_selection2_#{li_index_inc}"=>"#{order.line_items[li_index].item.id}",
        "quantity#{li_index_inc}"=>"1",
        "mc_gross_#{li_index_inc}"=>"#{order.line_items[li_index].unit_price}",
        "item_name#{li_index_inc}"=>"#{order.line_items[li_index].name}",
        "item_number#{li_index_inc}"=>"#{li_index_inc}",
      }
      params.merge!(this_item)
    end
    return params
  end
  
  test "if nil order params should raise" do
    assert_raise(RuntimeError) { OrderFinder.new(:params_order => nil).find_pending }
  end
  
  test "if order params are present with no entries in database should return nil" do
    pending_order = Factory.build(:johns_pending_order_for_bag_and_wallet)

    params_order = params_from_pending_order(pending_order)
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    assert_nil(order_found)
  end
  
  test "if order params match pending order in database should return that order" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)

    params_order = params_from_pending_order(pending_order)
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  test "with two similar orders should return the correct order" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_bag_and_wallet, :shop => matthias_shop)
    similar_pending_order =  Factory(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop) #has the same no of items and total price
    
    params_order = params_from_pending_order(pending_order)
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_equal(pending_order, order_found)
  end

  test "similar orders with less line items in param order than in pending order should return nil" do
    matthias_shop = Factory(:matthias_shop)
    pending_order = Factory(:johns_pending_order_for_jacket_and_belt, :shop => matthias_shop)

    params_order = params_from_pending_order(Factory.build(:johns_pending_order_for_jacket, :shop => matthias_shop))
    
    order_found = OrderFinder.new(:params_order => params_order).find_pending
    
    assert_nil(order_found)
  end

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
