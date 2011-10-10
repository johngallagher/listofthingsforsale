Rails.application.config.middleware.use OmniAuth::Builder do
  Rails.logger.debug "Rails env is #{Rails.env.inspect}"
  if Rails.env.production?
    provider :facebook, '175670452514877', '2a017518bf32595d84846f0e0bb8cfec'
  else
    provider :facebook, '258055290904307', '70219603c45d78038b3a8653cbd56591'
  end
end