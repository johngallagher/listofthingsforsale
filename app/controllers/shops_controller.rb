class ShopsController < ApplicationController
  # GET /shops
  # GET /shops.xml
  def index
    @shops = Shop.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops }
    end
  end

  def home_edit
    if session[:shop_id].nil?
      respond_to do |format|
        format.html { render :action => "new" }
      end
    else
      @shop = Shop.find(session[:shop_id])
      respond_to do |format|
        format.html { render 'edit', :object => @shop} # show.html.erb
      end
    end
  end

  def home
    if session[:shop_id].nil?
      respond_to do |format|
        format.html { redirect_to :action => "new" }
      end
    else
      @shop = Shop.find(session[:shop_id])
      respond_to do |format|
        format.html { redirect_to shop_url(@shop)} # show.html.erb
        format.js
      end
    end
  end
  
  # GET /shops/1
  # GET /shops/1.xml
  def show
    if params[:url].nil?
      @shop_ref = params[:id]
      @shop = Shop.find(@shop_ref)
    else
      @shop_ref = params[:url]
      @shop = Shop.where(:url => @shop_ref).first
    end
    logger.debug "Session is #{session.inspect}"
    
    
    if @shop.nil?
      respond_to do |format|
        format.html { render 'show_invalid_shop', :object => @shop_ref and return }
        format.js
      end
    end
    
    respond_to do |format|
      format.html { render 'show' => @shop} # show.html.erb
      format.js
    end
  end

  def show_users_shop
    respond_to do |format|
      format.html { render 'show', :shop => @shop} # show.html.erb
    end
  end

  def show_shop
    respond_to do |format|
      format.html { render 'show' => @shop} # show.html.erb
    end
  end
  # GET /shops/new
  # GET /shops/new.xml
  def new
    if user_signed_in?
      if current_user.shop
        @shop = current_user.shop
        respond_to do |format|
          format.html {  redirect_to :action => 'show', :id => @shop.id and return } # show.html.erb
        end
      end
    end
    
    @shop = Shop.new
    logger.debug "Making a new shop"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    if params[:url].nil?
      @shop_id = params[:id]
      @shop = Shop.find(@shop_id)
    else
      @shop = Shop.where(:url => params[:url]).first
      @shop_id = @shop.id
    end
    # logger.debug "session is #{session.inspect} and params are #{params}"
    unless session[:shop_id].to_i == @shop_id.to_i
      respond_to do |format|
        format.html { redirect_to(@shop, :notice => 'Shop cannot be edited.')} # show.html.erb
      end
    end      
  end


  # POST /shops
  # POST /shops.xml
  def create
    @shop_items_description = params[:shop][:description]

    @shop_name = nil
    @shop = Shop.new(:name => @shop_name, :description => @shop_items_description, :status => ShopStatus::LIVE_FREE, :url => (0...8).map{65.+(rand(25)).chr}.join.downcase)

    respond_to do |format|
      if @shop.save
        if user_signed_in?
          if current_user.shop.nil?
            current_user.shop = @shop
            current_user.save
          end
        end
        
        session[:shop_id] = @shop.id
        
        logger.debug "Params passed in are #{params}"
        
        @new_items = ItemGenerator.new(:new_description => @shop_items_description, :old_description => "", :items => []).generate_items
        @shop.items = @new_items
        # ItemGenerator.new(@shop_items_description).generate_items.each do |this_item|
        #   this_item.shop = @shop
        #   this_item.quantity = 1
        #   this_item.save
        #   logger.debug "this item was #{this_item.inspect}"
        # end

        format.html { redirect_to(@shop, :notice => 'Shop was successfully created.') }
        format.xml  { render :xml => @shop, :status => :created, :location => @shop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1
  # PUT /shops/1.xml
  def update
    logger.debug("Params passed into update were: #{params.inspect}")
    @shop = Shop.find(params[:id])

    if !params[:shop].nil? and !params[:shop][:url].nil?
      # we're updating the url so keep it on tab 2.
      session[:selected_tab] = 2
    elsif !params[:shop].nil? and !params[:shop][:payment_type].nil?
      session[:selected_tab] = 3
    elsif !params[:shop].nil? and !params[:shop][:description].nil?
      session[:selected_tab] = 1
    end
    
    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        logger.debug("params changed were #{params[:shop].inspect}")
        new_description = params[:shop][:description]
        old_description = @shop.description
        if !new_description.nil?
          @old_items = Array.new(@shop.items)
          @new_items = ItemGenerator.new(:new_description => new_description, :old_description => old_description, :items => @old_items).generate_items
          
          # Don't destroy items, just detach them from shop. We may have all sorts of orders for these items still in the pipeline.
          # @items_to_destroy = @shop.items - @new_items
          # logger.debug "Items to destroy are #{@items_to_destroy}"
          # @items_to_destroy.each do |this_item|
          #   this_item.destroy
          # end
          # logger.debug "new items were #{@new_items.count} and #{@new_items.inspect}"

          # 
          logger.debug "puts items before clear are #{@new_items.inspect}"
          @shop.items.clear
          @new_items.each do |this_item|
            @shop.items << Item.find(this_item.id)
          end

          @shop.save
          
          # @shop.save
        end
        logger.debug("After update Shop is #{@shop.inspect} with items #{@shop.items.inspect}")
        @item = @shop.items.first
        # respond_to do |format|
          format.html { render :action => "show", :local => { :shop => @shop, :item => @item} and return } # show.html.erb
          # format.js
        # end
        
        # format.html {render @shop }
        # # format.html { redirect_to(@shop, :notice => 'Shop was successfully updated.') }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.xml
  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to(shops_url) }
      format.xml  { head :ok }
    end
  end
  
  # def take_live
  #   @shop = Shop.find(params[:id])
  #   @shop.status = ShopStatus::LIVE_FREE
  #   @shop.url = (0...8).map{65.+(rand(25)).chr}.join.downcase
  #   respond_to do |format|
  #     if @shop.save
  #       format.html { redirect_to(@shop, :notice => 'Shop was successfully taken live.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
end
