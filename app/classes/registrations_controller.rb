class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        if request.referrer.include?("/users/")
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        else
          return render :json => {:success => true, :redirect => after_inactive_sign_up_path_for(resource)}
        end
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end
    
  protected

  def after_inactive_sign_up_path_for(resource)
    if session[:shop_id]
      @current_shop = Shop.find(session[:shop_id])
     # logger.debug "AIS Current Shop is #{@current_shop}"
      if @current_shop then
        @current_shop.user_id = resource.id
        @current_shop.paypal_email = resource.email
        @current_shop.save
        session[:selected_tab] = 2
      end
     # logger.debug "about to redirect to #{session[:shop_id]}"
      return shop_url(session[:shop_id])
    else
      new_shop_url
    end
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
      shop_url(current_user.shop.id)
    else
      new_shop_url
    end
  end
   
end