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
        format.html { render 'admin_show', :object => @shop} # show.html.erb
      end
    end
  end
  
  # GET /shops/1
  # GET /shops/1.xml
  def show
    if params[:url].nil?
      @shop = Shop.find(params[:id])
    else
      @shop = Shop.where(:url => params[:url]).first
    end
    logger.debug "Session is #{session.inspect}"
    if session[:shop_id].to_i == @shop.id
      logger.debug "session is our shop id"
      respond_to do |format|
        format.html { render 'admin_show', :object => @shop} # show.html.erb
      end
    else
      logger.debug "session is NOT our shop id"
      respond_to do |format|
        format.html { render 'show' => @shop} # show.html.erb
      end
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

    # if user is signed in
    # 
    #   if user already has a shop and they try and make one, 
    #     redirect them to their shop.
    #   else 
    #     Set user id on shop to the id of current signed in user.
    # 
    # if user isn't signed in
    #   set session shop id to  id of new shop
    # 
    # end




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
        
        ItemGenerator.new(@shop_items_description).generate_items.each do |this_item|
          this_item.shop = @shop
          this_item.quantity = 1
          this_item.save
          logger.debug "this item was #{this_item.inspect}"
        end

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
    @shop = Shop.find(params[:id])

    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        logger.debug("params changed were #{params[:shop].inspect}")
        new_description = params[:shop][:description]
        @shop.items.destroy_all
        ItemGenerator.new(new_description).generate_items.each do |this_item|
          this_item.shop = @shop
          this_item.quantity = 1
          this_item.save
          logger.debug "this item was #{this_item.inspect}"
        end
        
        format.html { redirect_to(@shop, :notice => 'Shop was successfully updated.') }
        format.xml  { head :ok }
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
