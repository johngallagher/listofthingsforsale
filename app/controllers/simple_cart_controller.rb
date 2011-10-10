class SimpleCartController < ApplicationController
  def home
    respond_to do |format|
      format.html { render 'show.html.erb' }
      format.js
    end
  end
  
  def show
    respond_to do |format|
      format.html { render 'show.html.erb' }
      format.js
    end
  end

  def change
    logger.debug "DATABASE operation happens here!"
    stock = 0
    if stock < 1 # we don't have enough stock
      respond_to do |format|
        format.js { render 'change'} #runs the javascript in the change.js.erb file - remove items out of stock and show as out of stock
      end
    else # we're good to go with stock so checkout
      respond_to do |format|
        format.js { render 'wow'}
      end
    end
  end
  
  def email_order
    @email_order = EmailOrder.new
    
    redirect_to email_order_url(@email_order)
  end
  
  def check_stock
    logger.debug "Params are #{params.inspect}"
    
    check_stock_items
    
    if @items_out_of_stock.empty?
      # Nothing out of stock so continue with checkout process
      
      create_pending_order
      
      if paypal_allowed?
        respond_to do |format|
          format.js { render 'simplecart_checkout'} # runs the usual simplecart checkout code
        end
      else
        session[:pending_order_id] = @pending_order.id
        render :update do |page|
            page.redirect_to 'email_orders/new'
         end
        # email_order
        # respond_to do |format|
        #   format.js { render 'email_orders/new', :content_type => Mime::HTML }
        #   # format.js { redirect_to :controller => "email_orders", :action => 'create', :content_type => Mime::HTML }
        # end
      end
      
    else
      flash[:error] = "Items that were out of stock have been removed."
      respond_to do |format|
        format.js { render 'check_stock' => @items_out_of_stock} # remove items out of stock and show as out of stock on list page
      end
    end
  end
  
  def paypal_allowed?
    this_shop_id = params[:shopid].to_i
    this_shop = Shop.find(this_shop_id)
    logger.debug "The shop before paypal allowed is #{this_shop.inspect}"
    return (this_shop.payment_type == Payments::Paypal)
  end
  
  def create_pending_order
    this_shop_id = params[:shopid].to_i
    this_shop = Shop.find(this_shop_id)
    if this_shop.nil? 
      return
    end
    
    final_total = BigDecimal.new(params[:finalTotal])
    order = Order.create(:shop => this_shop, :total_price => final_total, :status => Status::Pending, :currency => Currency::GBP)
    order.save!
    
    @items_out_of_stock = []
    items = params[:items]
    items.keys.each do |this_item_id|
      this_item = items[this_item_id]
      this_item_id = this_item["itemid"].to_i
      this_item_quantity = this_item["quantity"].to_i
      this_item_name = this_item["name"]
      this_item_unit_price = BigDecimal.new(this_item["amount"])
      this_item = Item.find(this_item_id)
      this_line_item = LineItem.create(:unit_price => this_item_unit_price, :quantity => this_item_quantity, :name => this_item_name, :item => this_item, :unit_price => this_item_unit_price)
      this_line_item.save
      order.line_items << this_line_item
    end

    order.save
    @pending_order = order
  end
  
  def check_stock_items
    @items_out_of_stock = []
    items = params[:items]
    items.keys.each do |this_item_id|
      this_item_wanted = items[this_item_id]
      this_item_wanted_id = this_item_wanted["itemid"]
      this_item_wanted_quantity = this_item_wanted["quantity"]
      
      if this_item_wanted_quantity.to_i > 1
        logger.error("User somehow added more than one Item to cart: #{this_item_wanted.inspect}")
      end
      
      if !StockChecker.new(:item_id => this_item_wanted_id, :quantity => this_item_wanted_quantity).in_stock?
        @items_out_of_stock << this_item_wanted
      end
    end
  end
  
  def validate_cart
    # Should set items with q > 1 to q of 1. Do this later.
  end
end
