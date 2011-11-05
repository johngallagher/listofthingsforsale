require 'test_helper'

class CategoryTest < Test::Unit::TestCase
  # On create
  test "given name contains space css classname should have a hyphen" do
    category = Category.create(:name => "on sale")
    assert_equal("on-sale", category.css_name)
  end
end