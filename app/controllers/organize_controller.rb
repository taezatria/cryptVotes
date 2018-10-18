class OrganizeController < ApplicationController
  before_action :check_user_login
  skip_before_action :verify_authenticity_token

  def home
    @status = role_user
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @menu = display_menu(@menu, @status)
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

  def add
    new_user = User.create(name: params[:name], idNumber: params[:id_number], email: params[:email], phone: params[:phone]);
    if params[:menu] == 'organizer'
      Organizer.create(user: new_user, election: Election.first, access_right_id: params[:access_right_id])
    end
    @status = role_user
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @menu = display_menu(@menu, @status)
    render :home
  end

  def get_data
    user = User.find(params[:id])
    org = Organizer.where(user_id: user.id, deleted_at: nil)
    render :json => { user: user, organizer: org }
  end

  private

  def check_user_login
    if !$redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
      flash[:error] = "You must login first !"
      redirect_back fallback_location: root_path
    end
  end

  def role_user
    $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).to_i
  end

  def display_menu(menu, status)
    if status == 1 
      menu = 'home' unless ["voter", "candidate"].include? menu
    elsif status == -1
      menu = 'home' unless ["access_right", "election", "organizer"].include? menu
    end
    menu
  end
end
