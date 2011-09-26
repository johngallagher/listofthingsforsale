How are we going to deal with Paypal?

So we get a callback to a controller.


2. We must post back the same request to make sure it came from Paypal servers:
notify = Paypal::Notification.new(request.raw_post)
if notify.acknowledge

3. Check status is completed
if notify.status == "Completed"

1. We must check the transaction hasn't already been processed:
if !Trans.count("*", :conditions => ["paypal_transaction_id = ?", notify.transaction_id]).zero?
end

4. If the transaction hasn't been processed, do the following:
check email of seller is correct
check payment amount and payment currency are correct
redirect to page which thanks the buyer. Somehow...




–	Confirm that the payment status is Completed.
PayPal sends IPN messages for pending and denied payments as well; do not ship until the payment has cleared.



–	Use the transaction ID to verify that the transaction has not already been processed, which prevents duplicate transactions from being processed.
Typically, you store transaction IDs in a database so that you know you are only processing unique transactions. –	Validate that the receiver’s email address is registered to you.
This check provides additional protection against fraud. –	Verify that the price, item description, and so on, match the transaction on your website.

7. Iftheverifiedresponsepassesthechecks,takeactionbasedonthevalueofthetxn_type variable if it exists; otherwise, take action based on the value of the reason_code variable.
8. IftheresponseisINVALIDortheresponsecodeisnot200,savethemessageforfurther investigation.



class PaymentController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  ActiveMerchant::Billing::Base.mode = :test
  def create
    @enrollment = current_user.enrollments.find(params[:id])
  end
  def notify
    logger.debug("Notified!")
    notify = Paypal::Notification.new(request.raw_post)
    # enrollment = Enrollment.find(notify.item_id)
    logger.debug("Before acknowledge: #{notify.inspect}")
    
    if notify.acknowledge
      logger.debug("After acknowledge!")
      # @payment = Payment.find_by_confirmation(notify.transaction_id) ||
      #   enrollment.invoice.payments.create(:amount => notify.amount,
      #     :payment_method => 'paypal', :confirmation => notify.transaction_id,
      #     :description => notify.params['item_name'], :status => notify.status,
      #     :test => notify.test?)
      # begin
      #   if notify.complete?
      #     @payment.status = notify.status
      #   else
      #     logger.error("Failed to verify Paypal's notification, please investigate")
      #   end
      # rescue => e
      #   @payment.status = 'Error'
      #   raise
      # ensure
      #   @payment.save
      # end
    end
    render :nothing => true
  end  
end
