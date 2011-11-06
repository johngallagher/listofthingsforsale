require 'test_helper'

class CategoryTest < Test::Unit::TestCase
  # On create
  test "given name contains space css classname should have a hyphen" do
    category = Category.create(:name => "On sale")
    assert_equal("on-sale", category.css_name)
  end
end