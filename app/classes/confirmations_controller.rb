
class ConfirmationsController < Devise::ConfirmationsController
  protected


  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    if session[:shop_id]
      shop_url(session[:shop_id])
    else
      new_shop_path
    end
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if session[:shop_id]
      @shop = Shop.find(session[:shop_id])
      @shop.user = resource # attach the user to the shop
      @shop.save
      shop_url(@shop.id)
    else
      #if we're here, we have no shop id session. That means the user don't have a shop yet.
      new_shop_path
    end
  end
  
end