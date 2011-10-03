class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    @current_shop = Shop.find(session[:shop_id])
    if @current_shop then
      @current_shop.user_id = resource.id
      @current_shop.paypal_email = resource.email
      @current_shop.save
    end
    shop_url(session[:shop_id])
  end
  
  
  # def after_sign_up_path_for(resource)
  #   after_sign_in_path_for(resource)
  # end
  # 
  # def after_sign_in_path_for(resource)
  #   after_sign_in_path_for(resource)
  # end
  #  
end