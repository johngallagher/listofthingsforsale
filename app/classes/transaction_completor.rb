class TransactionCompletor
  def initialize(args)
    @pending_order = args[:pending_order]
    @notification = args[:notification]
  end
  def complete_transaction
    logger.debug("Before complete transaction")
    completed_order = OrderCompletor.new(:notification => @notification, :pending_order => @pending_order).complete_order
    StockManager.new(:completed_order => completed_order).adjust_stock
    SimpleCartManager.clear_cart
    logger.debug("After complete transaction")
  end
end