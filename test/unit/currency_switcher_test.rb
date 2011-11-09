# encoding: UTF-8
require 'test_helper'

class CurrencySwitcherTest < ActiveSupport::TestCase
  test "should default to dollars for empty string" do
    assert_equal(Currency::USD, CurrencySwitcher.new('').get_currency)
  end
  test "should be pounds for single price" do
    currency = CurrencySwitcher.new('£3').get_currency
    assert_equal(Currency::GBP, currency)
  end
  test "should be pounds for single price with pence" do
    currency = CurrencySwitcher.new('£3.00').get_currency
    assert_equal(Currency::GBP, currency)
  end
end
