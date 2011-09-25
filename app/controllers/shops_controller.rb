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

  def show_public
    
    @shop = Shop.where("url = ?", params[:id]).find(:first)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shop }
    end
  end
  
  # GET /shops/1
  # GET /shops/1.xml
  def show

    logger.debug "Seesion is #{session.inspect}"
    if session[:shop_id].nil?
      respond_to do |format|
        format.html { redirect_to(:action => "new") }
        format.xml  { render :xml => @shop }
      end
      return
    else
      @shop = Shop.find(session[:shop_id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @shop }
      end
    end
  end

  # GET /shops/new
  # GET /shops/new.xml
  def new
    @shop = Shop.new
    logger.debug "Making a new shop"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    @shop = Shop.find(params[:id])
  end


  # POST /shops
  # POST /shops.xml
  def create
    @shop_items_description = params[:shop][:description_for_shop]
    @location = nil
    # @location = GeoLocation.find(request.remote_ip)
    # @remote_ip = request.env["HTTP_X_FORWARDED_FOR"]
    # logger.debug "Location is #{location.inspect} from ip #{request.remote_ip} also #{@remote_ip}"
    # @shop_name = ""
    # if @location[:city].nil? || @location[:city] == "(Unknown City)"
    #   if @location[:country].nil? || @location[:country] == "(Unknown Country)"
    #     @shop_name = "Shop in #{location[:city]}"
    #   else
    #     @shop_name = "Shop in #{location[:city]}, #{location[:country]}"
    #   end
    # else
      @shop_name = "My Shop"
    # end
    @shop = Shop.new(:name => @shop_name)

    respond_to do |format|
      if @shop.save
        session[:shop_id] = @shop.id
        
        logger.debug "Params passed in are #{params}"
        
        ItemGenerator.new(@shop_items_description).generate_items.each do |this_item|
          this_item.shop = @shop
          this_item.quantity = 1
          this_item.save
          logger.debug "this item was #{this_item.inspect}"
        end
        
        # @item_1 = Item.new(:name => "Test Item 1", :description_text => "Hello", :price => "1.50", :shop => @shop)
        # @item_2 = Item.new(:name => "Test Item 2", :description_text => "Hello there", :price => "4.00", :shop => @shop)
        # 
        # @item_1.save
        # @item_2.save

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
  
  def take_live
    @shop = Shop.find(params[:id])
    @shop.status = ShopStatus::LIVE_FREE
    @shop.url = (0...8).map{65.+(rand(25)).chr}.join.downcase
    respond_to do |format|
      if @shop.save
        format.html { redirect_to(@shop, :notice => 'Shop was successfully taken live.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end
end
