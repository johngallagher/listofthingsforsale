require 'test_helper'

class ItemGeneratorTest < Test::Unit::TestCase
  # No existing items
  test "one line should make one item" do
    generated_items = ItemGenerator.new(:existing_items => nil, :new_description => "iPhone $34 brand new").generate_items
    assert_equal(1, generated_items.count)
    iphone_item = Item.new(:name => "iPhone", :price => 34, :description_text => "brand new", :quantity => 1)
    assert_equal(iphone_item.attributes, generated_items.first.attributes)
  end
end