class ListsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    @list = List.new(params[:list])
    @list.save
    redirect_to list_path(@list)
  end

  def show
    @list = List.find(params[:id])
  end
end