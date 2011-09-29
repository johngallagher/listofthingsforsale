class PaymentNotificationsController < ApplicationController  
  protect_from_forgery :except => [:create]  
  def create
    logger.debug("Notified!")
    notify = Paypal::Notification.new(request.raw_post)
    # enrollment = Enrollment.find(notify.item_id)
    logger.debug("Before acknowledge: #{notify.inspect}")
    
    if notify.acknowledge
      logger.debug("Acknowledged!")
      # @payment = Payment.find_by_confirmation(notify.transaction_id) ||
      #   enrollment.invoice.payments.create(:amount => notify.amount,
      #     :payment_method => 'paypal', :confirmation => notify.transaction_id,
      #     :description => notify.params['item_name'], :status => notify.status,
      #     :test => notify.test?)
      # PaymentNotification.create!(:params => notify.params, :status => notify.params[:payment_status], :transaction_id => notify.params[:txn_id] )
      begin
        if notify.complete?
          logger.debug("Hurrah - success. Notify is #{notify.inspect}")
          # check buyer is correct and purchase amount and number of items are correct too.
          
        else
          logger.error("Failed. Notify was: #{notify.inspect}")
        end
      rescue => e
        raise
      ensure
      end
    end
    render :nothing => true  
  end  
end