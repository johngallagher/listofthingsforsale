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
  
  def check_stock
    logger.debug "DATABASE operation happens here!"
    logger.debug "Params are #{params.inspect}"
    
    check_stock_items
    
    if @items_out_of_stock.empty?
      # Nothing out of stock so continue with checkout process
      
      # Create a pending order in our system
      
      respond_to do |format|
        format.js { render 'simplecart_checkout'} # runs the usual simplecart checkout code
      end
    else
      respond_to do |format|
        format.js { render 'update_cart' => @items_out_of_stock} # remove items out of stock and show as out of stock on list page
      end
    end
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
