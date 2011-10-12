class PaymentNotificationsController < ApplicationController  
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:ipn]
  
  def ipn
    @paypal_notification = Paypal::Notification.new(request.raw_post)

    @payment_notification = PaymentNotification.create(:params => @paypal_notification.params, :status => @paypal_notification.params[:payment_status], :transaction_id => @paypal_notification.params[:txn_id] )
    @payment_notification.acknowledged = @paypal_notification.acknowledge
    @payment_notification.save
    
    begin
      if !@payment_notification.acknowledged
        logger.error("Spoofed notification - didn't come from Paypal - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end

      if !@paypal_notification.complete?
        logger.error("Order not completed - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end
      
      # Later.
      # if !DuplicateNotificationDetector.new(:notification => @payment_notification).is_unique?
      #   logger.error("Duplicate Notification: #{@payment_notification.inspect}")
      #   render :nothing => true and return
      # end
     # logger.debug("before pending order notification is #{@paypal_notification.inspect}")
      pending_order = OrderFinder.new(:params_order => @paypal_notification.params).find_pending
      if pending_order.nil?
        logger.error("Pending order not found. Hacking attempt or accidental submission by another seller - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end
      
      if BigDecimal.new(@paypal_notification.params["mc_gross"]) != pending_order.total_price
        logger.error("Payment not equal to order total - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end
      
      # Add extra validations later - for item unit price etc
      
      TransactionCompletor.new(:notification => @payment_notification, :pending_order => pending_order).complete_transaction

      render :nothing => true  

    rescue => e
      logger.error("Crash in notification validation. #{e.inspect} #{@paypal_notification.inspect}")
      raise
    ensure
    end
  end  
end
