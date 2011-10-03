class SessionsController < Devise::SessionsController
  def create
    super
    session[:shop_id] = current_user.shop.id
    logger.debug "Session created"
  end
  
  def destroy
    shop_id = session[:shop_id]
    super
    session[:shop_id] = shop_id
  end
end
