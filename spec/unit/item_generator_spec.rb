require 'spec_helper'

describe "ItemGenerator" do
  # No existing items
  it "one line should make one new item" do
    generated_items = ItemGenerator.new(:description => "iPhone $34 brand new").generate_items
    assert_equal(1, generated_items.count)
    iphone_item = Item.new(:name => "iPhone", :price => 34, :description_text => "brand new", :quantity => 1)
    assert(iphone_item.equal_to_item?(generated_items.first), "Failure message.")
  end
  it "items on home page should make three items" do
    description = "For example:\n\niPhone 3GS $70\nFender Guitar $280\nPocket Watch $5 Excellent condition"
    generated_items = ItemGenerator.new(:description => description).generate_items
    assert_equal(3, generated_items.length)
  end
  it "strings quartet one line should make one item" do
    description = "My Love is like a Red Red Rose arranged for String Quartet $3.50 Sheet music Score and Parts emailed as a PDF"
    generated_items = ItemGenerator.new(:description => description).generate_items
    assert_equal(1, generated_items.length)
  end
  it "strings quartet should make lots of items" do
    description = "My Love is like a Red Red Rose arranged for String Quartet $3.50 Sheet music: Score and Parts, emailed as a PDF\n\nWillkommen (from 'Cabaret') arranged for String Quartet $10 Sheet music: Score and Parts, emailed as a PDF\n\nWillkommen (from 'Cabaret') arranged for Voice and String Orchestra $15 Sheet music: Score and Parts, emailed as a PDF\n\nWaiting for the Federals arranged for String Quartet $3.50 Sheet music: Score and Parts, emailed as a PDF\n\nPride and Prejudice (Theme from the 1995 BBC Adaptation) $10 Sheet music: Score and Parts, emailed as a PDF\n\nThe Hut on Staffin Island arranged for String Quartet $5 Sheet music: Score and Parts, emailed as a PDF\n\nSpooteskerry arranged for String Quartet $3.50 Sheet music: Score and Parts, emailed as a PDF\n\nLast Spring (by Grieg) arranged for String Trio $5 Sheet Music: Score and Parts, emailed as a PDF\n\nCan't Help Loving That Man arrange for String Trio $10 Sheet Music: Score and Parts, emailed as a PDF\n\nLord Kelly's Reel arranged for String Quartet $5 Sheet Music: Score and Parts, emailed as a PDF\n\nHoneysuckle Rose arranged for String Quartet $8 Sheet Music: Score and Parts, emailed as a PDF\n\nPennies from Heaven arranged for String Quartet $8 Sheet Music: Score and Parts, emailed as a PDF\n\nLove Montage from 'Les Mis' arranged for String Quartet $10 Sheet Music: Score and Parts, emailed as a PDF\n\nAe Fond Kiss arranged for String Quartet $3.50 Sheet Music: Score and Parts, emailed as a PDF"
    generated_items = ItemGenerator.new(:description => description).generate_items
    assert_equal(14, generated_items.length)
  end
  it "one line with two categories" do
    generated_items = ItemGenerator.new(:description => "iPhone $34 brand new #phone #new").generate_items
    assert_equal(1, generated_items.count)
    
    generated_item = generated_items.first
    assert_equal("iPhone",    generated_item.name)
    assert_equal(34.0,        generated_item.price)
    assert_equal("brand new", generated_item.description_text)
    assert_equal(2,           generated_item.categories.count)
    assert_equal("Phone" ,    generated_item.categories.first.name)
    assert_equal("phone" ,    generated_item.categories.first.css_name)
    assert_equal("New",       generated_item.categories.second.name)
    assert_equal("new",       generated_item.categories.second.css_name)
  end
  # 1 Item
end