class OrganizeController < ApplicationController
  before_action :check_user_login

  def home
    @status = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).to_i
    @menu = 'home'
    @menu = params[:menu] if params[:menu].present?
    if @status == 1 
      @menu = 'home' unless ["voter", "candidate"].include? @menu
    elsif @status == -1
      @menu = 'home' unless ["access_right", "election", "organizer"].include? @menu
    end
    render :home
  end

  def change_password
    if params[:oldpassword].present? && params[:newpassword].present? && params[:retypepassword].present?
      user = User.find(session[:current_user_id])
      flash[:error] = 'Old password is wrong' if user.password != params[:oldpassword]
      flash[:error] = 'New password and retype password dont match' if params[:newpassword] != params[:retypepassword]
      if !flash[:error].present?
        user.password = params[:newpassword]
        user.save!
        flash[:notice] = 'Password saved successfully'
      end
    end
    redirect_back fallback_location: root_path
  end

  def logout
    $redis.del(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
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
