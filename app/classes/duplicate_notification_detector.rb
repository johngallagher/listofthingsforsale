class DuplicateNotificationDetector
  def initialize(args)
    @notification_to_check = args[:notification]
  end
  def is_unique?
    
  end

  def is_duplicate?
    !is_unique?
  end
end