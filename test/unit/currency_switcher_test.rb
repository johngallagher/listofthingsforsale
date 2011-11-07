require 'test_helper'

class CurrencySwitcherTest < ActiveSupport::TestCase
  test "should default to dollars for empty string" do
    assert_equal(Currency::USD, CurrencySwitcher.new("").get_currency)
  end
end
