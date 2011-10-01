require 'factory_girl'

# Sellers
Factory.define :user do |user|
end

Factory.define :matthias_seller, :class => "User" do |user|
  user.sequence(:id) { |n| n }
  user.sequence(:email) { |n| "matthias#{n}@espritdescalier.co.uk" }
  user.password "foobar"  
  user.password_confirmation { |u| u.password }
end


# Shops
Factory.define :matthias_shop, :class => "Shop" do |shop|
  shop.sequence(:id) { |n| n }
  shop.name "Matthias' List of Things for Sale"
  shop.after_create do |s|
    Factory(:matthias_seller, :shop => s)
  end
end


# Orders
Factory.define :pending_order_for_33_33, :class => "Order" do |order|
  order.buyer_paypal_email "" # on checkout there's no way of grabbing this, so when the order is pending it's blank.
  order.status Status::Pending
  order.total_price 33.33
  order.session_id "854f72119322a250f6f40adfffa4a11b"
  order.currency Currency::GBP
end

Factory.define :johns_pending_order_for_bag_and_wallet, :parent => :pending_order_for_33_33 do |order|
  order.after_create do |o|
    # add line items
    @b = Factory(:bag_item_with_line_item)
    o.line_items << @b.line_items.first
    @w = Factory(:wallet_item_with_line_item)
    o.line_items << @w.line_items.first
  end
end

# Can't get this working yet.
# Factory.define :johns_pending_order_for_bag_and_wallet_from_matthias_shop, :parent => :johns_pending_order_for_bag_and_wallet do |order|
#   order.after_create do |o|
#     o.shop { Shop.where(:name => "Matthias' List of Things for Sale").first || Factory(:matthias_shop) }
#   end
# end



# Deliberately similar to above - only difference is the number of items and type of items.
Factory.define :johns_pending_order_for_jacket_and_belt, :parent => :pending_order_for_33_33 do |order|
  order.after_create do |o|
    # add line items
    @j = Factory(:jacket_item_with_line_item)
    o.line_items << @j.line_items.first
    @b = Factory(:belt_item_with_line_item)
    o.line_items << @b.line_items.first
  end
end

Factory.define :johns_pending_order_for_jacket, :parent => :pending_order_for_33_33 do |order|
  order.after_create do |o|
    # add line items
    @j = Factory(:jacket_item_with_line_item)
    o.line_items << @j.line_items.first
  end
end



# Payment Notification
Factory.define :payment_notification do |t|
  t.params ""
  t.status ""
  t.transaction_id nil
  t.cart_id nil
  t.acknowledged false
end


# Wallet
Factory.define :wallet_item, :class => 'Item' do |item|
  item.name "wallet"
  item.description_text "this is a gorgeous wallet"
  item.price 22.22
  item.quantity 1
end

Factory.define :wallet_line_item, :class => 'LineItem' do |line_item|
  line_item.name "wallet"
  line_item.unit_price 22.22
  line_item.quantity 1
end

Factory.define :wallet_item_with_line_item, :parent => :wallet_item, do |item|
  item.after_create { |i| Factory(:wallet_line_item, :item => i) }
end


# Bag
Factory.define :bag_item, :class => 'Item' do |item|
  item.name "bag"
  item.description_text "handcrafted in the UK"
  item.price 11.11
  item.quantity 1
end

Factory.define :bag_line_item, :class => 'LineItem' do |line_item|
  line_item.name "bag"
  line_item.unit_price 11.11
  line_item.quantity 1
end

Factory.define :bag_item_with_line_item, :parent => :bag_item, do |item|
  item.after_create { |i| Factory(:bag_line_item, :item => i) }
end


# Jacket
Factory.define :jacket_item, :class => 'Item' do |item|
  item.name "jacket"
  item.description_text "amazing leather on this one."
  item.price 22.22
  item.quantity 1
end

Factory.define :jacket_line_item, :class => 'LineItem' do |line_item|
  line_item.name "jacket"
  line_item.unit_price 22.22
  line_item.quantity 1
end

Factory.define :jacket_item_with_line_item, :parent => :jacket_item, do |item|
  item.after_create { |i| Factory(:jacket_line_item, :item => i) }
end


# Belt
Factory.define :belt_item, :class => 'Item' do |item|
  item.name "belt"
  item.description_text "nice strap"
  item.price 11.11
  item.quantity 1
end

Factory.define :belt_line_item, :class => 'LineItem' do |line_item|
  line_item.name "belt"
  line_item.unit_price 11.11
  line_item.quantity 1
end

Factory.define :belt_item_with_line_item, :parent => :belt_item, do |item|
  item.after_create { |i| Factory(:belt_line_item, :item => i) }
end

