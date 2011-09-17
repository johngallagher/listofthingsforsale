class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    @current_shop = Shop.find(session[:shop_id])
    if @current_shop then
      @current_shop.status = ShopStatus::SAVED
      @current_shop.user_id = resource.id
      @current_shop.paypal_email = resource.email
      @current_shop.save
    end
    shop_url(session[:shop_id])
    # '/shops/' + session[:shop_id].to_s
  end
end