require 'test_helper'
require File.expand_path('../../paypal_ipn_mock', __FILE__)
require "payment_notifications_controller"

class PaymentNotificationsControllerTest < ActionController::TestCase

  setup do
    @controller = PaymentNotificationsController.new

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @ipn_params = {"mc_gross"=>"13.00",
      "protection_eligibility"=>"Eligible",
      "address_status"=>"confirmed",
      "item_number1"=>"1",
      "tax"=>"0.00",
      "payer_id"=>"MDKEM85G3LMLA",
      "address_street"=>"1 Main Terrace",
      "payment_date"=>"14:17:24 Sep 28, 2011 PDT",
      "option_name2_1"=>"shopid",
      "option_selection1_1"=>"21",
      "payment_status"=>"Completed",
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
  
  def test_should_generate_unacknowledged_notification_if_ipn_not_acknowledged
    #force ipn to return acknowledge as false
    ipn_callback = @ipn_params.merge("acknowledge" => "false")
    post :create, ipn_callback
    assert_response :success
  
    assert PaymentNotification.where(:transaction_id => ipn_callback[:txn_id], :acknowledged => false).all.count == 1
  end

  def test_should_generate_acknowledged_notification_if_ipn_acknowledged
    #force ipn to return acknowledge as false
    ipn_callback = @ipn_params.merge("acknowledge" => "true")
    post :create, ipn_callback
    assert_response :success
  
    assert PaymentNotification.where(:transaction_id => ipn_callback[:txn_id], :acknowledged => true).all.count == 1
  end
  
  
end


