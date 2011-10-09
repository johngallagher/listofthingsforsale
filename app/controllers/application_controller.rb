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
    # def after_sign_out_path_for(resource_or_scope)
    #   logger.debug "Heres the resource #{resource_or_scope.inspect}"
    # end
end
