Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '258055290904307', '70219603c45d78038b3a8653cbd56591'
end