# encoding: UTF-8
require 'spec_helper'

describe "CurrencySwitcher" do
  it "should default to dollars for empty string" do
    assert_equal(Currency::USD, CurrencySwitcher.new('').get_currency)
  end
  it "should default to dollars for nil description" do
    assert_equal(Currency::USD, CurrencySwitcher.new(nil).get_currency)
  end
  it "should be pounds for single price" do
    currency = CurrencySwitcher.new('name £3').get_currency
    assert_equal(Currency::GBP, currency)
  end
  it "should be pounds for single price with pence" do
    currency = CurrencySwitcher.new('name £3.00').get_currency
    assert_equal(Currency::GBP, currency)
  end
  it "should be dollars for single price" do
    currency = CurrencySwitcher.new('name $3').get_currency
    assert_equal(Currency::USD, currency)
  end
  it "should be dollars for single price with pence" do
    currency = CurrencySwitcher.new('name $3.00').get_currency
    assert_equal(Currency::USD, currency)
  end
  it "should be dollars for equal number of prices" do
    currency = CurrencySwitcher.new("name $3 \nname £3").get_currency
    assert_equal(Currency::USD, currency)
  end
  it "should handle multiple lines" do
    currency = CurrencySwitcher.new("name $3\nname  £3\nname £3").get_currency
    assert_equal(Currency::GBP, currency)
  end
  it "should handle default text on front page" do
    currency = CurrencySwitcher.new("For example:\n\niPhone 3GS £70\nFender Guitar £280\nPocket Watch $5 Excellent condition #new").get_currency
    assert_equal(Currency::GBP, currency)
  end
  it "should handle default text on front page with crs and newlines" do
    currency = CurrencySwitcher.new("For example:\r\n\r\niPhone 3GS £70 Excellent\r\nFender Guitar £280 Excellent\r\nPocket Watch $5 Excellent condition #new").get_currency
    assert_equal(Currency::GBP, currency)
  end
  it "should handle default text on front page with crs and newlines first" do
    currency = CurrencySwitcher.new("For example:\r\n\r\niPhone 3GS £70 Excellent\r\nFender Guitar £280 Excellent\r\nPocket Watch $5 Excellent condition #new").get_currency
    assert_equal(Currency::GBP, currency)
  end
end
