class PaymentNotificationsController < ApplicationController  
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  
  def create
    @paypal_notification = Paypal::Notification.new(request.raw_post)

    @notification = PaymentNotification.create!(:params => @paypal_notification.params, :status => @paypal_notification.params[:payment_status], :transaction_id => @paypal_notification.params[:txn_id] )
    @notification.acknowledged = @paypal_notification.acknowledge
    @notification.save
    
    begin
      if !@notification.acknowledged
        logger.error("Spoofed notification - didn't come from Paypal - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end

      if !@paypal_notification.complete?
        logger.error("Order not completed - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end
      
      if !DuplicateNotificationDetector.new(:notification => @notification).is_unique?
        logger.error("Duplicate Notification: #{@notification.inspect}")
        render :nothing => true and return
      end
      
      pending_order = OrderFinder.new(:order_params => @paypal_notification.params).find_pending
      if pending_order.nil?
        logger.debug("Pending order not found - #{@paypal_notification.inspect}")
        render :nothing => true and return
      end
      
      TransactionCompletor.new(:notification => @notification, :pending_order => pending_order).complete_transaction

      render :nothing => true  

    rescue => e
      logger.error("Crash in notification validation. #{e.inspect} #{@paypal_notification.inspect}")
      raise
    ensure
    end
  end  
end
