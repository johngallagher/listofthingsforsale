class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def self.current_user_shop_url(arg, options = {})
    before_filter(options) do |controller|
      controller.send(:current_user_shop_url, arg)
    end
  end
  
  protected

  
  private

  # Overwriting the sign_out redirect path method
  # def after_sign_in_path_for(resource_or_scope)
  #   root_url + current_user.shop.url
  # end
  
  def after_sign_out_path_for(resource_or_scope)
    logger.debug "Session in after sign out path #{session.inspect}"
    # logged_out_users_shop = Shop.find(session[:old_shop_id])
    # root_url + logged_out_users_shop.url
    root_url
  end
  
  
end
