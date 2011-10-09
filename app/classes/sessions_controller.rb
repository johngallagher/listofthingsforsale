class SessionsController < Devise::SessionsController
  def create
    super
    session[:old_shop_id] = nil
    session[:shop_id] = current_user.shop.id
    @current_users_shop_id = current_user.shop.id
  end
  
  def destroy
    logger.debug "Session after logout is #{session.inspect}"
    # old_shop_id = session[:shop_id]
    # session[:shop_id] = nil
    super
    # session[:old_shop_id] = @current_users_shop_id
    # logger.debug "Session after after logout is #{session.inspect}"
  end
end
