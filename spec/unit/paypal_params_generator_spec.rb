require 'spec_helper'

describe "PaypalParamsGenerator" do
  before(:each) do
    @matthias_shop = Factory.create(:matthias_shop)
    @order = Factory.create(:johns_pending_order_for_bag_and_wallet, :shop => @matthias_shop)

    # make sure the factory has set it all up right.
    @order.shop_id.should_not ==   nil
    @order.status.should == Status::Pending
    @order.session_id.empty?.should_not ==   true
    @order.session_id.blank?.should_not ==   true
    @order.session_id.nil?.should_not ==   true
    @order.total_price.should_not ==   nil
  end

  it "test status is the same" do
    paypal_params = PaypalParamsGenerator.new(:order => @order, :payment_status => Status::Completed).generate_params
    paypal_params["payment_status"].should == Status::Completed
  end
end
