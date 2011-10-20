class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    if params[:PayerID]       # Only way we can subscribe to business is with a Paypal payment callback
      subscribe_to_business
    else
      subscribe_to_personal
    end
  end
  
  def subscribe_to_personal
    @user.plan_selected = true
    if @user.subscription
      #cancel subscription with paypal
      @user.subscription = nil
    end
    
    if @user.save
      render :json => {:success => true, :plan_name => "Personal"}
    else
      render :json => {:success => false, :errors => @user.errors}
    end
  end
  
  def subscribe_to_business
    @user.plan_selected = true
    @subscription = @user.build_subscription
    @subscription.plan = Plan.business_plan
    @subscription.paypal_customer_token = params[:PayerID]
    @subscription.paypal_payment_token = params[:token]
    @subscription.email = @subscription.paypal.checkout_details.email
    @subscription.save_with_payment
    @user.save
    redirect_to "/" + @user.shop.url, :notice => "Subscription successful! Thankyou."
    return
  end
end
