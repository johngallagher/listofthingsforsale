require 'test_helper'

class PaypalParamsGeneratorTest < ActionController::TestCase
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
  
  # test "raise exception for nil order" do
  #   assert_raise(PaypalParamsGenerator.new(:order => nil).generate_params)
  # end
  
  test "test status is the same" do
    paypal_params = PaypalParamsGenerator.new(:order => @order, :payment_status => Status::Completed).generate_params
    assert paypal_params["payment_status"] == Status::Completed
  end
end
