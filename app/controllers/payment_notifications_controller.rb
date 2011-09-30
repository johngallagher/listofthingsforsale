class PaymentNotificationsController < ApplicationController  
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]  
  def create
    # logger.debug("Notified!")
    notify = Paypal::Notification.new(request.raw_post)

    # logger.debug("Before acknowledge: #{notify.inspect}")
    
    @notification = PaymentNotification.create!(:params => notify.params, :status => notify.params[:payment_status], :transaction_id => notify.params[:txn_id] )
    if notify.acknowledge
      @notification.acknowledged = true
      begin
        if notify.complete?
          if DuplicateNotificationDetector.new(:notification => @notification).is_unique?
            pending_order = OrderFinder.new(:notify_params => notify.params).find_pending
            if pending_order
              completed_order = OrderCompletor.new(:notification => @notification, :order => pending_order).complete_order
              StockManager.new(:order => completed_order).adjust_stock
              SimpleCartManager.new.clear_cart
            else
              logger.debug("Notification didn't come from us. Order not found.")
            end
          else
            logger.error("Duplicate Notification: #{@notification.inspect}")
          end
        else
          logger.error("Spoofed Notification: #{@notification.inspect}")
        end
      rescue => e
        raise
      ensure
      end
    else
      logger.debug("Not acknowledged")
      @notification.acknowledged = false
    end
    @notification.save
    render :nothing => true  
  end  
end

