# encoding: UTF-8
require 'spec_helper'

describe DescriptionFilterer do
  context "nil description" do
    it "returns nil" do
      assert_nil(DescriptionFilterer.new(nil).replace_unwanted_currencies)
    end
  end
  context "when dollars are the chosen currency and one price in pounds" do
    it "converts the pound price to dollars" do
      @description = "iPhone $34\nDial phone £4\nTeletubby $4"
      correct_description = "iPhone $34\nDial phone $4\nTeletubby $4"
      new_description = DescriptionFilterer.new(@description).replace_unwanted_currencies
      assert_equal(correct_description, new_description)
    end
  end
  context "when pounds are the chosen currency and one price in dollars" do
    it "converts the dollar price to pounds" do
      @description = "iPhone £34\nDial phone $4\nTeletubby £4"
      correct_description = "iPhone £34\nDial phone £4\nTeletubby £4"
      new_description = DescriptionFilterer.new(@description).replace_unwanted_currencies
      assert_equal(correct_description, new_description)
    end
  end
  context "when pounds are the chosen currency and two prices in dollars" do
    it "converts the dollar price to pounds" do
      @description = "iPhone £34\nDial phone $4\nDial rotary $23\nTeletubby £4\nTeletubbies £14"
      correct_description = "iPhone £34\nDial phone £4\nDial rotary £23\nTeletubby £4\nTeletubbies £14"
      new_description = DescriptionFilterer.new(@description).replace_unwanted_currencies
      assert_equal(correct_description, new_description)
    end
  end
end