require 'test_helper'

class OrderFinderTest < ActiveSupport::TestCase
  setup do
    @order_params = {"mc_gross"=>"13.00",
       "protection_eligibility"=>"Eligible",
       "address_status"=>"confirmed",
       "item_number1"=>"1",
       "tax"=>"0.00",
       "payer_id"=>"MDKEM85G3LMLA",
       "address_street"=>"1 Main Terrace",
       "payment_date"=>"14:17:24 Sep 28, 2011 PDT",
       "option_name2_1"=>"shopid",
       "option_selection1_1"=>"21",
       "payment_status"=>"Pending",
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
       "business"=>"king_1316956168_biz@gmail.com",
       "address_country"=>"United Kingdom",
       "num_cart_items"=>"1",
       "mc_handling1"=>"0.00",
       "address_city"=>"Wolverhampton",
       "verify_sign"=>"ACTQ-IEZ9gMsbO0Pw-mucb3t592GAazwT2TyT4UVXsV9nnRONUdx7DGt",
       "payer_email"=>"buyer_1316956501_per@gmail.com",
       "mc_shipping1"=>"0.00",
       "option_name1_1"=>"itemid",
       "txn_id"=>"1E232785L98112148",
       "payment_type"=>"instant",
       "option_selection2_1"=>"12",
       "last_name"=>"User",
       "address_state"=>"West Midlands",
       "item_name1"=>"new",
       "receiver_email"=>"king_1316956168_biz@gmail.com",
       "payment_fee"=>"",
       "quantity1"=>"1",
       "receiver_id"=>"5EC9ZN6KQH47N",
       "txn_type"=>"cart",
       "mc_gross_1"=>"13.00",
       "mc_currency"=>"GBP",
       "residence_country"=>"GB",
       "test_ipn"=>"1",
       "transaction_subject"=>"Shopping Cart",
       "payment_gross"=>"",
       "ipn_track_id"=>"LlEfeRjfHawhnM1zyCcqrA"}
  end
  
  test "if nil order params should raise" do
    assert_raise(RuntimeError) { OrderFinder.new(:order_params => nil).find_pending }
  end
  
  test "if order params are present with no entries in database should return nil" do
    order_found = OrderFinder.new(:order_params => @order_params).find_pending
    assert_nil(order_found)
  end
  
  test "if order params match pending order in database should return that order" do
    @johns_pending_order = Factory.create(:johns_pending_order_for_bag_and_wallet_from_matthias_shop)

    @order_params = params_for_order_matching_pending
    
    order_found = OrderFinder.new(:order_params => @order_params).find_pending
    
    assert_equal(@johns_pending_order, order_found)
  end

  test "if status, shop id, session id and gross are the same for two orders should return the correct order" do
    @johns_pending_order = Factory.create(:johns_pending_order_for_bag_and_wallet_from_matthias_shop)
    @johns_pending_order.save
    
    @johns_similar_pending_order = Factory.create(:johns_pending_order_for_jacket_and_belt) # two items, same bottom line price, same session id.
    @johns_similar_pending_order.shop = @johns_pending_order.shop #must come from the same instance of shop
    @johns_similar_pending_order.save
    
    @order_params = params_for_order_matching_pending
    
    order_found = OrderFinder.new(:order_params => @order_params).find_pending
    
    assert_equal(@johns_pending_order, order_found)
  end
  
  def params_for_order_matching_pending
    {  "protection_eligibility"=>"Eligible",
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

       "num_cart_items"=>"#{@johns_pending_order.line_items.count}",
       
       "payment_status"=>"Pending",
       "business"=>"#{@johns_pending_order.shop.user.email}",
       "receiver_email"=>"#{@johns_pending_order.shop.user.email}",
       "payer_email"=>"#{@johns_pending_order.buyer_paypal_email}",

       #transaction id
       "txn_id"=>"1E232785L98112148",
       
       #item 1
       "option_name1_1"=>"shopid",
       "option_selection1_1"=>"#{@johns_pending_order.shop_id}",
       
       "option_name2_1"=>"itemid",
       "option_selection2_1"=>"#{@johns_pending_order.line_items.first.item.id}",
       "quantity1"=>"1",
       "mc_gross_1"=>"#{@johns_pending_order.line_items.first.unit_price}",
       "item_name1"=>"#{@johns_pending_order.line_items.first.name}",
       "item_number1"=>"1",

       #item 2
       "option_name1_2"=>"shopid",
       "option_selection1_2"=>"#{@johns_pending_order.shop_id}",
       
       "option_name2_2"=>"itemid",
       "option_selection2_2"=>"#{@johns_pending_order.line_items.second.item.id}",
       "quantity2"=>"1",
       "mc_gross_2"=>"#{@johns_pending_order.line_items.second.unit_price}",
       "item_name2"=>"#{@johns_pending_order.line_items.second.name}",
       "item_number2"=>"2",
       
       #total
       "mc_gross"=>"#{@johns_pending_order.total_price}",

       "payment_gross"=>"#{@johns_pending_order.total_price}",
       
       "session_id"=>"#{@johns_pending_order.session_id}" 
       }
  end
end
