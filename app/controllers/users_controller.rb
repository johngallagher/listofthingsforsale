class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    @plan = Plan.find(params[:user][:plan_id])
    if @plan.name == "Business"
      # Create new subscription
    else
      # Cancel subscription
    end
    if @user.save
      render :json => {:success => true, :plan_name => @plan.name}
      # render "show_plan", :locals => {:plan => @user.plan}
    else
      render :json => {:success => false, :errors => @user.errors}
      # render "change_plan"
    end
  end
end
