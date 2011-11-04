require 'test_helper'

# item  price description quantity  category
# x     x     -           -         -
# x     x     x           -         -
# x     x     -           x         -
# x     x     x           x         - y
# x     x     -           -         x y
# x     x     x           -         x y
# x     x     -           x         x y
# x     x     x           x         x y

class LineParserTest < ActiveSupport::TestCase
  # No Matches
  test "only name should give no matches" do
    assert_nil(LineParser.parse("item name"))
  end
  test "only price should give no matches" do
    assert_nil(LineParser.parse("$3.45"))
  end
  test "only price and description should give no matches" do
    assert_nil(LineParser.parse("$3.45 excellent"))
  end
  # Matches
  test "name and price" do
    parsed_item = LineParser.parse("item name $3.45")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal nil,                     parsed_item[:cat1]
  end
  test "name price and description" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",   parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal nil,                     parsed_item[:cat1]
  end
  test "name price and quantity" do
    parsed_item = LineParser.parse("item name $3.45 +5")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal nil,                     parsed_item[:cat1]
  end
  test "name price and category" do
    parsed_item = LineParser.parse("item name $3.45 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal "wow",                   parsed_item[:cat1]
  end
  test "name price description and quantity" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal nil,                     parsed_item[:cat1]
  end
  test "name price quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 +5 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal "wow",                   parsed_item[:cat1]
  end
  test "name price description and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal "wow",                   parsed_item[:cat1]
  end
  test "name price description quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal "wow",                   parsed_item[:cat1]
  end
end
