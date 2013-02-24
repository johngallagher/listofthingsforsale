class ListsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    @list = List.new(params[:list])
    @list.save
    redirect_to @list
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    list = List.find(params[:id])
    list.update_attributes(params[:list])
    redirect_to list
  end
end