class SessionsController < Devise::SessionsController
  def create
    super
    session[:old_shop_id] = nil
    if current_user.shop
      session[:shop_id] = current_user.shop.id
    end
  end
  
  def destroy
   # logger.debug "Session after logout is #{session.inspect}"
    super
  end
end
