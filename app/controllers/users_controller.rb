class UsersController < ApplicationController
  def change_plan
    @user = User.find(params[:id])
    @plan = Plan.find(params[:user][:plan_id])
    @user.plan = @plan
    if @user.save
      render :json => {:success => true, :plan_name => @plan.name}
      # render "show_plan", :locals => {:plan => @user.plan}
    else
      render :json => {:success => false, :errors => @user.errors}
      # render "change_plan"
    end
  end
end