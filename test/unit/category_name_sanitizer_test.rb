require 'test_helper'

class CategoryNameSanitizerTest < Test::Unit::TestCase
  test "should replace space with hyphen" do
    assert_equal("on-sale", CategoryNameSanitizer.new("on sale").sanitize)
  end
end