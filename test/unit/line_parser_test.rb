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
    assert_equal [],                     parsed_item[:categories]
  end
  test "name price and description" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",   parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal [],                     parsed_item[:categories]
  end
  test "name price and quantity" do
    parsed_item = LineParser.parse("item name $3.45 +5")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal [],                     parsed_item[:categories]
  end
  test "name price and category" do
    parsed_item = LineParser.parse("item name $3.45 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal ["wow"],                   parsed_item[:categories]
  end
  test "name price description and quantity" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal [],                     parsed_item[:categories]
  end
  test "name price quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 +5 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                     parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal ["wow"],                   parsed_item[:categories]
  end
  test "name price description and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal ["wow"],                   parsed_item[:categories]
  end
  test "name price description quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal "excellent condition",  parsed_item[:description_text]
    assert_equal 5,                     parsed_item[:quantity]
    assert_equal ["wow"],                   parsed_item[:categories]
  end
  test "strings quartet one line should make one item" do
    parsed_item = LineParser.parse("My Love is like a Red Red Rose arranged for String Quartet $3.50 Sheet music Score and Parts emailed as a PDF")
    assert_not_nil(parsed_item)
    assert_equal "My Love is like a Red Red Rose arranged for String Quartet",             parsed_item[:name]
    assert_equal 3.50,                  parsed_item[:price]
    assert_equal "Sheet music Score and Parts emailed as a PDF",  parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal [],                   parsed_item[:categories]
  end
  # Categories
  test "name price and 1 category" do
    parsed_item = LineParser.parse("item name $3.45 #wow")
    assert_equal "item name",             parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                   parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal ["wow"],                   parsed_item[:categories]
  end
  test "name price and 6 categories" do
    parsed_item = LineParser.parse("item name $3.45 #cat1 #cat2 #cat3 #cat4 #cat5 #cat6")
    assert_equal "item name",           parsed_item[:name]
    assert_equal 3.45,                  parsed_item[:price]
    assert_equal nil,                   parsed_item[:description_text]
    assert_equal 1,                     parsed_item[:quantity]
    assert_equal ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6"],      parsed_item[:categories]
  end
end
