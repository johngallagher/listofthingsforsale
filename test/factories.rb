require 'factory_girl'

Factory.define :user do |user|
end

Factory.define :matthias_seller, :class => "User" do |user|
  user.sequence(:email) { |n| "matthias#{n}@espritdescalier.co.uk" }
  user.password "foobar"  
  user.password_confirmation { |u| u.password }
end

Factory.define :matthias_shop, :class => "Shop" do |shop|
  shop.name "Matthias' List of Things for Sale"
  shop.after_create do |s|
    Factory(:matthias_seller, :shop => s)
  end
end

Factory.define :order do |order|
end

# Factory.define :johns_pending_order, :parent => :order do |order|
#   order.status "Pending"
#   order.total_price 33.33
#   order.session_id "854f72119322a250f6f40adfffa4a11b"
# end

# Factory.define :johns_pending_order_with_email, :parent => :johns_pending_order do |order|
#   order.sequence(:buyer_paypal_email) { |n| "john#{n}@synapticmishap.com" }
# end

Factory.define :johns_pending_order_for_bag_and_wallet_from_matthias_shop, :parent => :order do |order|
  order.sequence(:buyer_paypal_email) { |n| "john#{n}@synapticmishap.com" }
  order.status "Pending"
  order.total_price 33.33
  order.session_id "854f72119322a250f6f40adfffa4a11b"

  order.after_create do |o|
    
    #add line items
    @b = Factory(:bag_item_with_line_item)
    o.line_items << @b.line_items.first
    @w = Factory(:wallet_item_with_line_item)
    o.line_items << @w.line_items.first
    
    @s = Factory(:matthias_shop)
    @s.orders << o
  end
end

Factory.define :payment_notification do |t|
  t.params ""
  t.status ""
  t.transaction_id nil
  t.cart_id nil
  t.acknowledged false
end

Factory.define :wallet_item, :class => 'Item' do |item|
  item.name "wallet"
  item.description_text "this is a gorgeous wallet"
  item.price 22.22
  item.quantity 1
end

Factory.define :wallet_line_item, :class => 'LineItem' do |line_item|
  line_item.unit_price 22.22
  line_item.quantity 1
end

Factory.define :wallet_item_with_line_item, :parent => :wallet_item, do |item|
  item.after_create { |i| Factory(:wallet_line_item, :item => i) }
end


Factory.define :bag_item, :class => 'Item' do |item|
  item.name "bag"
  item.description_text "handcrafted in the UK"
  item.price 11.11
  item.quantity 1
end

Factory.define :bag_line_item, :class => 'LineItem' do |line_item|
  line_item.unit_price 11.11
  line_item.quantity 1
end

Factory.define :bag_item_with_line_item, :parent => :bag_item, do |item|
  item.after_create { |i| Factory(:bag_line_item, :item => i) }
end


# Factory.define :johns_order_for_bag_and_wallet, :parent => :johns_pending_order_from_matthias_shop do |order|
#   order.after_create do |order|
#     @b = Factory(:bag_item_with_line_item)
#     order.line_items << @b.line_items.first
#     @w = Factory(:wallet_item_with_line_item)
#     order.line_items << @w.line_items.first
#   end
# end

