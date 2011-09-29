class PaymentNotificationsController < ApplicationController  
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]  
  def create
    logger.debug("Notified!")
    notify = Paypal::Notification.new(request.raw_post)

    logger.debug("Before acknowledge: #{notify.inspect}")
    
    @notification = PaymentNotification.create!(:params => notify.params, :status => notify.params[:payment_status], :transaction_id => notify.params[:txn_id] )
    if notify.acknowledge
      @notification.acknowledged = true
      begin
        if notify.complete?
          # check buyer is correct and purchase amount and number of items are correct too.
          
        else

        end
      rescue => e
        raise
      ensure
      end
    else
      @notification.acknowledged = false
    end
    @notification.save
    render :nothing => true  
  end  
end