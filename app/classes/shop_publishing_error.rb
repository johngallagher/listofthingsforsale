class ShopPublishingError
  attr_accessor :domain
  attr_accessor :message
  
  def initialize(args)
    self.domain = args[:domain]
    self.message = args[:message]
  end
end