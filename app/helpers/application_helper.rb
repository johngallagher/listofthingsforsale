module ApplicationHelper
  def current_user_shop_url
    logger.debug "Current url is #{@current_user_shop_url}"
    if session[:shop_id]
      if @current_user_shop.nil? and @current_user_shop_url.nil?
        @current_user_shop ||= Shop.find(session[:shop_id])
        if @current_user_shop
          @current_user_shop_url ||= @current_user_shop.url
        end
      end
    end
  end
  
  def current_page_in?(*pages)
    pages.select {|page| current_page?(page)}.compact.any? 
  end
end
