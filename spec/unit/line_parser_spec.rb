# encoding: UTF-8
require 'spec_helper'
require 'line_parser'
# item  price description quantity  category
# x     x     -           -         -
# x     x     x           -         -
# x     x     -           x         -
# x     x     x           x         - y
# x     x     -           -         x y
# x     x     x           -         x y
# x     x     -           x         x y
# x     x     x           x         x y

describe "LineParser" do
  # No Matches
  it "only name should give no matches" do
    assert_nil(LineParser.parse("item name"))
  end
  it "only price should give no matches" do
    assert_nil(LineParser.parse("$3.45"))
  end
  it "only price and description should give no matches" do
    assert_nil(LineParser.parse("$3.45 excellent"))
  end
  # Matches
  it "name and price" do
    parsed_item = LineParser.parse("item name $3.45")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == []
  end
  it "name price and description" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == "excellent condition"
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == []
  end
  it "name price and quantity" do
    parsed_item = LineParser.parse("item name $3.45 +5")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 5
    parsed_item[:categories].should == []
  end
  it "name price and category" do
    parsed_item = LineParser.parse("item name $3.45 #wow")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == ["wow"]
  end
  it "name price description and quantity" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == "excellent condition"
    parsed_item[:quantity].should == 5
    parsed_item[:categories].should == []
  end
  it "name price quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 +5 #wow")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 5
    parsed_item[:categories].should == ["wow"]
  end
  it "name price description and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition #wow")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == "excellent condition"
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == ["wow"]
  end
  it "name price description quantity and category" do
    parsed_item = LineParser.parse("item name $3.45 excellent condition +5 #wow")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == "excellent condition"
    parsed_item[:quantity].should == 5
    parsed_item[:categories].should == ["wow"]
  end
  it "strings quartet one line should make one item" do
    parsed_item = LineParser.parse("My Love is like a Red Red Rose arranged for String Quartet $3.50 Sheet music Score and Parts emailed as a PDF")
    assert_not_nil(parsed_item)
    parsed_item[:name].should == "My Love is like a Red Red Rose arranged for String Quartet"
    parsed_item[:price].should == 3.50
    parsed_item[:description_text].should == "Sheet music Score and Parts emailed as a PDF"
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == []
  end
  
  # Categories
  it "name price and 1 category" do
    parsed_item = LineParser.parse("item name $3.45 #wow")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 1
    parsed_item[:categories].should == ["wow"]
  end
  it "name price and 6 categories" do
    parsed_item = LineParser.parse("item name $3.45 #cat1 #cat2 #cat3 #cat4 #cat5 #cat6")
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == nil
    parsed_item[:quantity].should == 1
    assert_equal ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6"],      parsed_item[:categories]
  end
  
  it "can parse for pounds" do
    parsed_item = LineParser.parse("item name £3.45 excellent condition +5 #wow", :currency => Currency::GBP)
    parsed_item[:name].should == "item name"
    parsed_item[:price].should == 3.45
    parsed_item[:description_text].should == "excellent condition"
    parsed_item[:quantity].should == 5
    parsed_item[:categories].should == ["wow"]
  end
end
