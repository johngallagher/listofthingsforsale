require 'test_helper'

class ItemParserTest < ActiveSupport::TestCase
  test "description should be optional" do
    parsed_item = ItemParser.parse("item name $3.45")
    assert parsed_item[:name] == "item name"
    assert parsed_item[:price] == "3.45"
  end
  test "description should be parsed out" do
    parsed_item = ItemParser.parse("item name $3.45 excellent condition")
    assert parsed_item[:name] == "item name"
    assert parsed_item[:price] == "3.45"
    assert parsed_item[:description] == "excellent condition"
  end
end
