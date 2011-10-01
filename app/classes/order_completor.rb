class OrderCompletor
  def initialize(args)
    @pending_order = args[:pending_order]
    @notification = args[:notification]
  end
  def complete_order
    @pending_order.status = Status::Completed
    return @pending_order
  end
  
end