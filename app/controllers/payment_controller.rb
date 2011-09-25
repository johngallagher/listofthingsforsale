class PaymentController < ApplicationController
  include ActiveMerchant::Billing::Integrations
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
