class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    @current_shop = Shop.find(session[:shop_id])
    if @current_shop then
      @current_shop.user_id = resource.id
      @current_shop.paypal_email = resource.email
      @current_shop.save
      session[:selected_tab] = 2
    end
    shop_url(session[:shop_id])
  end
  
  
  def after_sign_up_path_for(resource)
    @redirect_url = root_url
    if session[:shop_id]
      session[:selected_tab] = 2
      @current_user_shop = Shop.find(session[:shop_id])
      if @current_user_shop
        @redirect_url = root_url + @current_user_shop.url
      end
    end
    return @redirect_url
  end
  
  def after_sign_in_path_for(resource)
    if current_user.shop
      root_url + current_user.shop.url
    end
  end
   
end