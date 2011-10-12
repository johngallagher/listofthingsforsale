class EmailOrdersController < ApplicationController
  def index
    new
  end
  def new
    order_to_email_id = session[:pending_order_id].to_i
    
    # # id is required to deal with form
    # if @pending_order.nil?
    #   @pending_order = Order.new
    # end
    @order = Order.find(order_to_email_id)
   # logger.debug "Ordeer is #{@order.inspect}"
    @seller = @order.shop.user
    if @seller.nil? or @seller.email.nil?
      # if seller is nil, the seller hasn't signed up
      render 'seller_unknown' and return
    else
      @text = ""
      Order.last.line_items.each { |l| @text << l.name + ", " }
      @email_order = EmailOrder.new(:id => 1, :content => "I'd like to order the following items please: #{@text}")
    end
  end

  def create
   # logger.debug "params into create were #{params.inspect}"
    order_to_email_id = session[:pending_order_id].to_i
    @order = Order.find(order_to_email_id)
    @seller = @order.shop.user
   # logger.debug "Order is #{@order.inspect}"
   # logger.debug "Seller is #{@seller.inspect}"
   # logger.debug "params to construct with are #{params[:email_order].inspect}"

    email = params[:email_order][:email]
    sender_name = params[:email_order][:sender_name]
    content = params[:email_order][:content]
    @email_order = EmailOrder.new(:email => email, :content => content, :sender_name => sender_name, :seller_email => @seller.email, :order => @order)
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
