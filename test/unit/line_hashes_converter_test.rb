require 'test_helper'

class LineHashesConverterTest < Test::Unit::TestCase
  def setup
    @existing_item_1 = Factory.build(:excellent_condition_item_1)
    @existing_item_2 = Factory.build(:excellent_condition_item_2)
    @line_hash_1 = {:name => "item 1",                   :price => 11.11, :description_text => "excellent condition", :quantity => 1}
    @line_hash_2 = {:name => "item belt and trousers 2", :price => 11.11, :description_text => "excellent condition", :quantity => 1}
    @line_hash_1_with_categories = {:name => "item 1", :price => 11.11, :description_text => "excellent condition", :quantity => 1, :categories => ["cat1", "cat2"]}
  end
  # with no items
  test "with no existing items one line hash should create an item" do
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1]).convert_to_items
    assert_equal(converted_items.length, 1)
    first_item     = converted_items.first
    assert_equal(Item,                  first_item.class)
    assert_equal("item 1",              first_item.name)
    assert_equal(11.11,                 first_item.price)
    assert_equal("excellent condition", first_item.description_text)
    assert_equal(1,                     first_item.quantity)
  end

  test "with no existing items two line hashes should create items" do
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1, @line_hash_2]).convert_to_items
    assert_equal(converted_items.length, 2)
    first_item     = converted_items.first
    second_item    = converted_items.second
    assert_equal(Item,                  first_item.class)
    assert_equal("item 1",              first_item.name)
    assert_equal(11.11,                 first_item.price)
    assert_equal("excellent condition", first_item.description_text)
    assert_equal(1,                     first_item.quantity)
    assert_equal(Item,                  second_item.class)
    assert_equal("item belt and trousers 2",              second_item.name)
    assert_equal(11.11,                 second_item.price)
    assert_equal("excellent condition", second_item.description_text)
    assert_equal(1,                     second_item.quantity)
  end
  
  # with two items with same price and description
  # no changing
  test "no items have been changed " do
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1, @line_hash_2], :existing_items => [@existing_item_1, @existing_item_2]).convert_to_items
    
    assert_equal(converted_items, [@existing_item_1, @existing_item_2])
    assert_equal("item 1", @existing_item_1.name)
    assert_equal("item belt and trousers 2", @existing_item_2.name)
  end
  
  # changing one item, no moving
  test "second item name has been changed " do
    @line_hash_2[:name] = "item belt and trousers"
    
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1, @line_hash_2], :existing_items => [@existing_item_1, @existing_item_2]).convert_to_items
    
    assert_equal(converted_items, [@existing_item_1, @existing_item_2])
    assert_equal("item 1", @existing_item_1.name)
    assert_equal("item belt and trousers", @existing_item_2.name)
  end
  test "first item name has been changed " do
    @line_hash_1[:name] = "item"
    
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1, @line_hash_2], :existing_items => [@existing_item_1, @existing_item_2]).convert_to_items
    
    assert_equal(converted_items, [@existing_item_1, @existing_item_2])
    assert_equal("item", @existing_item_1.name)
    assert_equal("item belt and trousers 2", @existing_item_2.name)
  end
  
  # with two items with same price and description
  # changing one item then moving up
  test "second item name changed and moved up " do
    @line_hash_2[:name] = "item belt and trousers"
    
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_2, @line_hash_1], :existing_items => [@existing_item_1, @existing_item_2]).convert_to_items
    
    assert_equal(converted_items, [@existing_item_2, @existing_item_1])
    assert_equal("item 1", @existing_item_1.name)
    assert_equal("item belt and trousers", @existing_item_2.name)
  end
  # changing one item then moving down
  test "first item name changed and moved down" do
    @line_hash_1[:name] = "item"
    
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_2, @line_hash_1], :existing_items => [@existing_item_1, @existing_item_2]).convert_to_items
    
    assert_equal(converted_items, [@existing_item_2, @existing_item_1])
    assert_equal("item", @existing_item_1.name)
    assert_equal("item belt and trousers 2", @existing_item_2.name)
  end
  
  # categories
  test "one line hash with two categories should create item with two categories" do
    converted_items = LineHashesConverter.new(:line_hashes => [@line_hash_1_with_categories]).convert_to_items
    assert_equal(converted_items.length, 1)
    item     = converted_items.first
    assert_equal(Item,                  item.class)
    assert_equal("item 1",              item.name)
    assert_equal(11.11,                 item.price)
    assert_equal("excellent condition", item.description_text)
    assert_equal(1,                     item.quantity)
    
    assert_equal(2,                     item.categories.count)
    assert_equal(Category,              item.categories.first.class)
    assert_equal("cat1" ,               item.categories.first.name)
    assert_equal(Category,              item.categories.second.class)
    assert_equal("cat2",                item.categories.second.name)
  end
end