class PaymentNotification < ActiveRecord::Base
  # serialize :params  
  # after_create :mark_cart_as_purchased  

# private  
#   def mark_cart_as_purchased  
#     if status == "Completed"  
#       # Send simple cart a js message to clear out the cart. Or maybe clear that cookie.
#     end  
#   end  
end
