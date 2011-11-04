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

  # GET /shops/1
  # GET /shops/1.xml
  def show
    if params[:url]
      @shop_ref = params[:url]
      @shop = Shop.where(:url => @shop_ref).first
    else
      @shop_ref = params[:id]
      begin
        @shop = Shop.find(@shop_ref)
        redirect_to "/" + @shop.url 
        return
      rescue
      end
    end
    if @shop.nil?
      respond_to do |format|
        format.html { render 'show_invalid_shop', :object => @shop_ref and return }
      end
    end

    current_user_editing_own_shop = ((session[:shop_id].to_i == @shop.id) or (user_signed_in? and @shop.user == current_user))
    if (!current_user_editing_own_shop and @shop.status == ShopStatus::Offline)
      respond_to do |format|
        format.html { render 'show_invalid_shop', :object => @shop_ref and return }
      end
    end
    
    respond_to do |format|
      format.html { render 'show' =>  @shop }
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
   # logger.debug "Making a new shop"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    @shop = Shop.find(session[:shop_id].to_i)
  end


  def show_current_user_list
    if current_user and current_user.shop
      redirect_to "/#{current_user.shop.url}"
    elsif session[:shop_id]
      @shop_id = session[:shop_id]
      @shop = Shop.find(@shop_id)
      redirect_to "/" + @shop.url
    else
      render 'no_shop_yet'
    end
  end
  
  # POST /shops
  # POST /shops.xml
  def create
    session[:selected_tab] = 2
    @shop_items_description = params[:shop][:description]

    @shop_name = nil
    @shop_url = (0...8).map{65.+(rand(25)).chr}.join.downcase
    @shop = Shop.new(:name => @shop_name, :description => @shop_items_description, :url => @shop_url)

    @new_items = ItemGenerator.new(:description => @shop_items_description).generate_items
    # @new_items = ItemGenerator.new(:new_description => @shop_items_description, :old_description => "", :items => []).generate_items
    @shop.items = @new_items

    if user_signed_in?
      if current_user.shop.nil?
        @shop.user = current_user
      end
    end
    
    if @shop.save
      session[:shop_id] = @shop.id
      
      respond_to do |format|
        format.html { redirect_to "/" + @shop.url }
        # format.html { redirect_to(@shop, :notice => 'Shop was successfully created.') }
        format.xml  { render :xml => @shop, :status => :created, :location => @shop }
      end
    else
      respond_to do |format|
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

    updated_list = (!params[:shop].nil? and !params[:shop][:description].nil?)
    updated_config = (!params[:shop].nil? and !params[:shop][:payment_type].nil?)
    updated_url = (!params[:shop].nil? and !params[:shop][:url].nil?)
    updated_about_me = (!params[:shop].nil? and !params[:shop][:about_me].nil?)
    updated_background = (!params[:shop].nil? and !params[:shop][:background_id].nil?)
    
    hide_all_panes_after_update = !updated_background
    
    respond_to do |format|
      if @shop.update_attributes(params[:shop])
       # logger.debug("params changed were #{params[:shop].inspect}")
        new_description = params[:shop][:description] unless params[:shop].nil?
        old_description = @shop.description
        if new_description.present?
          @old_items = Array.new(@shop.items)
          @new_items = ItemGenerator.new(:items => @old_items, :description => new_description).generate_items
          # @new_items = ItemGenerator.new(:new_description => new_description, :old_description => old_description, :items => @old_items).generate_items
          @shop.items.clear
          @new_items.each do |this_item|
            @shop.items << Item.find(this_item.id)
          end
        end
        @shop.save

        format.html { redirect_to "/#{@shop.url}" and return }
        format.js { render :action => "update", :locals => {:shop => @shop, :hide_all => hide_all_panes_after_update }}
        
      else
        format.html { render :action => "edit" and return }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity and return }
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
  
  def prepublish
    @shop = Shop.where(:url => params[:url]).first
    ShopPublisher.new(:shop => @shop).prepublish
    render :action => "prepublish"
  end

  def publish
    @shop = Shop.where(:url => params[:url]).first
    @shop.status = ShopStatus::Online
    @shop.save
    render :action => "refresh"
  end
  
  def unpublish
    @shop = Shop.where(:url => params[:url]).first
    @shop.status = ShopStatus::Offline
    @shop.save
    render :action => "refresh"
  end
end

