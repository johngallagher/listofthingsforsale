require 'test_helper'

class LineHashesConverterTest < Test::Unit::TestCase
  # with two items with same price and description
  # changing existing lines
  test "no items have been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    line_hash_1 = {:name => "item 1", :price => 11.11, :description_text => "excellent condition"}
    line_hash_2 = {:name => "item 2", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = LineHashesConverter.new(:line_hashes => [line_hash_1, line_hash_2], :existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
    assert_equal("item 1", existing_item_1)
    assert_equal("item 2", existing_item_2)
  end
  test "second item name has been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    line_hash_1 = {:name => "item 1", :price => 11.11, :description_text => "excellent condition"}
    line_hash_2 = {:name => "item", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = LineHashesConverter.new(:line_hashes => [line_hash_1, line_hash_2], :existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
    assert_equal("item 1", existing_item_1)
    assert_equal("item", existing_item_2)
  end
  test "first item name has been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    line_hash_1 = {:name => "item", :price => 11.11, :description_text => "excellent condition"}
    line_hash_2 = {:name => "item 2", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = LineHashesConverter.new(:line_hashes => [line_hash_1, line_hash_2], :existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
    assert_equal("item", existing_item_1)
    assert_equal("item 2", existing_item_2)
  end
end