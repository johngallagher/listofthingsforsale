# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'description_filterer'

describe DescriptionFilterer do
  context "dollars are the chosen currency and one price in pounds" do
    it "converts the pound price to dollars" do
      @description = "iPhone $34\nDial phone £4\nTeletubby $4"
      correct_description = "iPhone $34\nDial phone $4\nTeletubby $4"
      new_description = DescriptionFilterer.new(@description).replace_unwanted_currencies
      assert_equal(correct_description, new_description)
    end
    
  end
end