class PaymentNotificationsController < ApplicationController  
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  
  def create
    # logger.debug("Notified!")
    @notify = Paypal::Notification.new(request.raw_post)

    # logger.debug("Before acknowledge: #{notify.inspect}")
    
    @notification = PaymentNotification.create!(:params => @notify.params, :status => @notify.params[:payment_status], :transaction_id => @notify.params[:txn_id] )
    if @notify.acknowledge
      @notification.acknowledged = true
      begin
        if @notify.complete?
          validate_notification
        else
          logger.error("Order not completed - #{@notify.inspect}")
        end
      rescue => e
        logger.error("Crash in notification validation. #{e.inspect} #{@notify.inspect}")
        raise
      ensure
      end
    else
      logger.error("Spoofed notification - didn't come from Paypal - #{@notify.inspect}")
      @notification.acknowledged = false
    end
    @notification.save
    render :nothing => true  
  end  
end

def validate_notification
  if DuplicateNotificationDetector.new(:notification => @notification).is_unique?
    pending_order = OrderFinder.new(:notify_params => @notify.params).find_pending
    if pending_order
      TransactionCompletor.new(:notification => @notification, :pending_order => pending_order).complete_transaction
    else
      logger.debug("Notification didn't come from us. Order not found.")
    end
  else
    logger.error("Duplicate Notification: #{@notification.inspect}")
  end
end