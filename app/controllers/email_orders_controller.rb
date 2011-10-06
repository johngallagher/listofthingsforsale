class EmailOrdersController < ApplicationController
  def new
    # id is required to deal with form
    if @pending_order.nil?
      @pending_order = Order.new
    end
    @email_order = EmailOrder.new(:id => 1, :order => @pending_order)
  end

  def create
    @email_order = EmailOrder.new(params[:email_order])
    if @email_order.save
      redirect_to('/', :notice => "Order was successfully sent.")
    else
      flash[:alert] = "You must fill all fields."
      render 'new'
    end
  end
  
  def show
    render 'show'
  end
end
