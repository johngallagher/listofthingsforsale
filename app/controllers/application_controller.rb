class ApplicationController < ActionController::Base
  protect_from_forgery
  private

    # Overwriting the sign_out redirect path method
    # def after_sign_out_path_for(resource_or_scope)
    #   logger.debug "Heres the resource #{resource_or_scope.inspect}"
    # end
end
