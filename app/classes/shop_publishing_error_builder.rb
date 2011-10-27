NoUser = "Sign up or login"
UnverifiedUser = "Verify user"
NoPlanSelected = "Select plan"
NoPaypalEmail = "Enter your paypal email address"

class ShopPublishingErrorBuilder
  def self.no_user_error
    ShopPublishingError.new(:domain => ErrorDomains::Account, :message => ErrorMessages::NoUser)
  end
  def self.unverified_user_error
    ShopPublishingError.new(:domain => ErrorDomains::Account, :message => ErrorMessages::UnverifiedUser)
  end
  def self.no_plan_selected_error
    ShopPublishingError.new(:domain => ErrorDomains::Account, :message => ErrorMessages::NoPlanSelected)
  end
  def self.no_paypal_email_error
    ShopPublishingError.new(:domain => ErrorDomains::Config, :message => ErrorMessages::NoPaypalEmail)
  end
end