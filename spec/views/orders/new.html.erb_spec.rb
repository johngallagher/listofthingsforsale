require 'spec_helper'

describe "orders/new.html.erb" do
  before(:each) do
    assign(:order, stub_model(Order,
      :shop_id => 1,
      :shop_id => 1,
      :buyer_paypal_email => "MyString"
    ).as_new_record)
  end

  it "renders new order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orders_path, :method => "post" do
      assert_select "input#order_shop_id", :name => "order[shop_id]"
      assert_select "input#order_shop_id", :name => "order[shop_id]"
      assert_select "input#order_buyer_paypal_email", :name => "order[buyer_paypal_email]"
    end
  end
end
