class ShopPublisher
  def initialize(args)
    @shop = args[:shop]
  end
  
  def prepublish
    @shop.publishing_errors = []
    user_signed_up?
    user_verified?
    plan_selected?
    paypal_email_entered?
  end
  
  def user_signed_up?
    if @shop.user
      return true
    else
      @shop.publishing_errors << ShopPublishingErrorBuilder.no_user_error
      return false
    end
  end
  
  def user_verified?
    if @shop.user and @shop.user.verified?
      return true
    else
      @shop.publishing_errors << ShopPublishingErrorBuilder.unverified_user_error
      return false
    end
  end
  
  def plan_selected?
    if @shop.user and @shop.user.plan_selected?
      return true
    else
      @shop.publishing_errors << ShopPublishingErrorBuilder.no_plan_selected_error
      return false
    end
  end

  def paypal_email_entered?
    if @shop.payment_type == Payments::Paypal and !@shop.paypal_email.present?
      @shop.publishing_errors << ShopPublishingErrorBuilder.no_paypal_email_error
      return false
    else
      return true
    end
  end
end