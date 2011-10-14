How do we integrate simple cart with what we want?

Flow

1. User clicks on add to cart
2. Item is added to cart. MVP - we sell out immediately.
3. Add to cart button is disappeared/greyed out.
4. They checkout.
5. At this point, we need to send a custom field with details of their order into Paypal.

How do we uniquely identify the order?

We need:

Shop id
Item id
Item quantity

so an example might be:

shop id: 5
"item_number1"=>"1"
"item_id1"=>"34"
"quantity1"=>"7"

Maybe we don't even need shop id, since each product should have it's unique id...

Let's put it in there though.

6. We get the callback from Paypal with the IPN. 
7. Post it back to paypal with acknowledge.
8. Check all the details are correct - payment amount, buyer etc
9. Check the order is complete.
10. If all these things are NOT in place, handle the error - maybe email someone, enter the tx into a suspicious list etc.
11. If all the above is fine:
Clear out simple cart
Make new order with items in the callback
Subtract the items in the relevant shops from the order.
Save the order with any other info we need to store historically.




Make an order for each shop so they can see their order history.

Shop 

has many orders


Order

belongs_to: shop
has many line items

ordered on:date
shop_id:integer
buyer_paypal_email:string



Line Item

has one product
belongs to one order

t.decimal  "unit_price"
t.integer  "product_id"
t.integer  "quantity"

t.integer  "order_id"



item

belongs to order



Objects
PaymentNotification
always created - even if it's a spoof notification
holds the original params that were sent to us

Order


For Payment Notifications Controller

PaymentNotification.create!(:params => notify.params, :status => notify.params[:payment_status], :transaction_id => notify.params[:txn_id] )

if notify.acknowledge
  begin
    if notify.complete?
      check buyer is correct
      check purchase amount and number of items are correct too.

      
    else
      logger.error("Failed. Notify was: #{notify.inspect}")
    end
  rescue => e
    raise
  ensure
  end
else
  #
end

Purchase flow V2
----------------


1. User clicks on add to cart
2. Item is added to cart. MVP - we sell out immediately. Add to cart button is disappeared/greyed out.
3. User clicks on checkout
    - Check that everything in the cart is still in stock. 
        If it's not, take the out of stock items out of the cart, refresh the list and show error message
        If everything is in stock, continue.
    - Rails gets sent a message to create a new Order that stores ip address, shop id, line items and total price. Set status to "pending payment"
    - Simple cart does it's thing - submits ip address, shop id, line item details (item id, price, quantity) and total price to Paypal


4. We get a notify callback to PaymentNotificationController
  
5. Post it back to paypal to acknowledge
  If paypal don't acknowledge, the notification was spoofed
    set notification.acknowledged to false
    exit 
    
  If paypal acknowledge successfully, 
    set notification.acknowledged to true
    continue

6. Check the order is complete.
  If it isn't, the payment hasn't been made. So log error and exit. Maybe send an email to the buyer and seller saying "this transaction was refused etc"

7. Find a PaymentNotification with the same transaction ID as the notify callback.
  If we find another notification with the same tx id, we log an error in the log file - duplicate transaction id and exit.
  If not, create a payment notification from the params.

8. Find an Order with status of pending payment, the same ip address, the same shop id and seller email, the same line item details, and same total price as in the notify object.
  If we don't find an order, someone has tried to buy fraudulently, so log error to log file
  If we find one, the order is genuine. Attach the payment notification to the order and add the buyers email address to the order.

9. Set status of the found order to "Completed" and save
10. Decrease the quantity of item for each line item from the order by one
11. Clear out simple cart

