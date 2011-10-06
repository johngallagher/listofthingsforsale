class UserNotifier < ActionMailer::Base
  default :from => "jgediting@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.activation.subject
  #
  def activation
    @greeting = "Hi"

    mail :to => "john@synapticmishap.co.uk"
  end
  
   def order_notification(sender)
     @sender = sender
     mail(:to => sender.seller_email,
          :from => sender.email,
          :subject => "New Order")
  end
  
end
