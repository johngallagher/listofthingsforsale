require 'test_helper'
require 'transaction_completor'

class TransactionCompletorTest < ActionController::TestCase
  setup do
    @notification = Factory.build(:payment_notification, :params => "",  :status => "", :transaction_id => "")
    @pending_order = Factory.build(:order, :status => "pending")
    @transaction_completor = TransactionCompletor.new(:notification => @notification, :pending_order => @pending_order)
  end
  
  test "when we complete transaction order should be completed" do
    completed_order = Factory.build(:order, :status => "completed")
    
    order_completor = mock('order_completor')
    OrderCompletor.expects(:new).with(:notification => @notification, :pending_order => @pending_order).returns(order_completor)
    order_completor.expects(:complete_order).returns(completed_order)
    
    stock_manager = mock('stock_manager')
    StockManager.expects(:new).with(:completed_order => completed_order).returns(stock_manager)
    stock_manager.expects(:adjust_stock)
    
    SimpleCartManager.expects(:clear_cart)
    
    @transaction_completor.complete_transaction
  end
end