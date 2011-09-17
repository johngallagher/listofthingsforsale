# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Things3::Application.initialize!

config.action_mailer.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address  => "mail.synapticmishap.co.uk",
  :port  => 25,
  :user_name  => "john+synapticmishap.co.uk",
  :password  => "stanl3ykubrick",
  :authentication  => :login
}