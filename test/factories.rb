require 'factory_girl'

Factory.define :order do |f|
  f.shop_id 1
  f.ordered_on nil
  f.sequence(:buyer_paypal_email) { |n| "foo#{n}@example.com" }
  f.status "pending"
end

Factory.define :payment_notification do |t|
  t.params ""
  t.status ""
  t.transaction_id nil
  t.cart_id nil
  t.acknowledged false
end