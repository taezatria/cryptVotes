class OrganizeController < ApplicationController
  before_action :check_user_login

  def dashboard
    render :dashboard
  end

  def logout
    reset_session
    flash[:notice] = "You've been logged out"
    redirect_to root_path
  end

  private

  def check_user_login
    if !$redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
      flash[:error] = "You must login first !"
      redirect_back fallback_location: root_path
    end
  end
end
