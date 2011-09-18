class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new
    @shop = Shop.find(params[:shop_id])
    @item.shop = @shop

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])
    @shop = Shop.find(params[:shop_id])
    @item.shop = @shop
    respond_to do |format|
      if @item.save
        format.html { redirect_to(@shop, :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @shop_for_item, :status => :created, :location => @shop_for_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shop_for_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])
    @shop_for_item = @item.shop

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@shop_for_item, :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @shop_for_item = @item.shop
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(@shop_for_item) }
      format.xml  { head :ok }
    end
  end
end
