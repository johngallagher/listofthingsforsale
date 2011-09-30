require 'spec_helper'

describe "orders/index.html.erb" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :shop_id => 1,
        :shop_id => 1,
        :buyer_paypal_email => "Buyer Paypal Email"
      ),
      stub_model(Order,
        :shop_id => 1,
        :shop_id => 1,
        :buyer_paypal_email => "Buyer Paypal Email"
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Buyer Paypal Email".to_s, :count => 2
  end
end
