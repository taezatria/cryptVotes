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
    new_user = User.create(
      name: params[:add_name], 
      idNumber: params[:add_id_number], 
      email: params[:add_email], 
      phone: params[:add_phone],
      approved: true
    )
    if params[:menu] == 'organizer'
      Organizer.create(
        user: new_user, 
        election_id: params[:add_election_id], 
        access_right_id: params[:add_access_right_id]
      )
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def get_data
    user = User.find_by(id: params[:user_id], deleted_at: nil)
    if params[:menu] == 'organizer'
      other = Organizer.find_by(id: params[:other_id], deleted_at: nil)
    elsif params[:menu] == 'candidate'
      other = Candidate.find_by(id: params[:other_id], deleted_at: nil)
    elsif params[:menu] == 'voter'
      other = Voter.find_by(id: params[:other_id], deleted_at: nil)
    else
      user = nil
      other = nil
    end
    render :json => { user: user, other: other }
  end

  def alter
    the_user = User.find(params[:edit_user_id])
    the_user.email = params[:edit_email]
    the_user.username = params[:edit_username]
    the_user.save
    if params[:menu] == 'organizer'
      org = Organizer.find(params[:edit_org_id])
      org.election_id = params[:edit_election_id]
      org.access_right_id = params[:edit_access_right_id]
      org.save
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def discard
    if params[:menu] == 'organizer'
      Organizer.discard(params[:delete_org_id])
    end
    redirect_to organize_path(menu: params[:menu])
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
