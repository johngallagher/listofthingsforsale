require 'test_helper'

class OrderFinderTest < ActiveSupport::TestCase
  test "if nil order params should return nil" do
    order_found = OrderFinder.new(:order_params => nil).find_pending
    assert_nil(order_found)
  end
end
