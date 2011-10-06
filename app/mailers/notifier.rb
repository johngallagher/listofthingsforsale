class Notifier < ActionMailer::Base

  def order_notification(sender)
    @sender = sender
    mail(:to => sender.seller_email,
         :from => sender.email,
         :subject => "New Order")
 end
end
