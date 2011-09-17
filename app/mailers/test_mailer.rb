class TestMailer < ActionMailer::Base
  def signup_notification(user)
    @greeting = "Hi"

    mail :to => "john@synapticmishap.co.uk"
    
    # recipients "#{user.name} <#{user.email}>"
    # from       "My Forum "
    # subject    "Please activate your new account"
    # sent_on    Time.now
    # body       { :user => user, :url => activate_url(user.activation_code, :host => user.site.host) }
  end
end
