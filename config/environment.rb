# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Things3::Application.initialize!

Things3::Application.configure do
  config.action_mailer.delivery_method = :smtp
end

# Ensure the gateway is in test mode
 ActiveMerchant::Billing::Base.gateway_mode = :production
 ActiveMerchant::Billing::Base.integration_mode = :production
