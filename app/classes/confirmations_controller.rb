
class ConfirmationsController < Devise::ConfirmationsController
  protected


  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    shop_url(session[:shop_id])
    # '/shops/' + session[:shop_id].to_s
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    @current_user_id = resource.id
    # now get the shop for this logged in user
    @current_shop = Shop.where("user_id = ?", @current_user_id).find(:first)
    if @current_shop
      @current_shop.status = ShopStatus::CONFIRMED
      @current_shop.save
      shop_url(session[:shop_id])
    end
  end
  
end