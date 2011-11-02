require 'test_helper'

class LineHashesConverterTest < Test::Unit::TestCase
  # with two items with same price and description
  # changing existing lines
  test "no items have been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    new_item_hash_1 = {:name => "item 1", :price => 11.11, :description_text => "excellent condition"}
    new_item_hash_2 = {:name => "item 2", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = DescriptionConverter.new(:existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
  end
  test "second item name has been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    new_item_hash_1 = {:name => "item 1", :price => 11.11, :description_text => "excellent condition"}
    new_item_hash_2 = {:name => "item", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = DescriptionConverter.new(:existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
  end
  test "first item name has been changed " do
    existing_item_1 = Factory.build(:excellent_condition_item_1)
    existing_item_2 = Factory.build(:excellent_condition_item_2)
    new_item_hash_1 = {:name => "item", :price => 11.11, :description_text => "excellent condition"}
    new_item_hash_2 = {:name => "item 2", :price => 11.11, :description_text => "excellent condition"}
    
    converted_items = DescriptionConverter.new(:existing_items => [existing_item_1, existing_item_2]).convert_to_items
    
    assert_equal(converted_items.first, existing_item_1)
    assert_equal(converted_items.second, existing_item_2)
  end
end