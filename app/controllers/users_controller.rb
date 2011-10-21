class UsersController < ApplicationController
  before_filter :find_user
  before_filter :check_for_cancel, :only => [:update]
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def update
    @user.plan_selected = true
    if params[:PayerID]       # Only way we can subscribe to business is with a Paypal payment callback
      subscribe_to_business
    else
      subscribe_to_personal
    end
  end
  
  def subscribe_to_personal
    if @user.subscription
      #cancel subscription with paypal
      @user.subscription.destroy
      @user.subscription = nil
    end
    
    if @user.save
      render :json => {:success => true, :plan_name => "Personal"}
    else
      render :json => {:success => false, :errors => @user.errors}
    end
  end
  
  def subscribe_to_business
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
  
private

  def check_for_cancel
    if params[:commit] == "Cancel"
      render :json => {:success => true, :plan_name => @user.subscription_plan_name }
      return
    end
  end
end
