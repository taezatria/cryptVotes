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
    if params[:menu] == 'organizer'
      new_user = User.create(
        name: params[:add_name], 
        idNumber: params[:add_id_number], 
        email: params[:add_email], 
        phone: params[:add_phone],
        approved: true
      )
      Organizer.create(
        user: new_user, 
        election_id: params[:add_election_id], 
        access_right_id: params[:add_access_right_id]
      )
    elsif params[:menu] == 'voter'
      new_user = User.create(
        name: params[:add_name], 
        idNumber: params[:add_id_number], 
        email: params[:add_email], 
        phone: params[:add_phone],
        approved: true
      )
      Voter.create(
        user: new_user,
        election_id: params[:add_election_id]
      )
    elsif params[:menu] == 'access_right'
      AccessRight.create(
        name: params[:add_name]
      )
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def get_data
    if params[:menu] == 'organizer'
      user = User.find_by(id: params[:user_id], deleted_at: nil)
      other = Organizer.find_by(id: params[:other_id], deleted_at: nil)
    elsif params[:menu] == 'candidate'
      user = User.find_by(id: params[:user_id], deleted_at: nil)
      other = Candidate.find_by(id: params[:other_id], deleted_at: nil)
    elsif params[:menu] == 'voter'
      user = User.find_by(id: params[:user_id], deleted_at: nil)
      other = Voter.find_by(id: params[:other_id], deleted_at: nil)
    elsif params[:menu] == 'election'
      user = Election.find_by(id: params[:user_id], deleted_at: nil)
      other = { start_date: user.start_date.strftime("%Y-%m-%d"), end_date: user.end_date.strftime("%Y-%m-%d") }
    else
      user = nil
      other = nil
    end
    render :json => { user: user, other: other }
  end

  def alter
    if params[:menu] == 'organizer'
      the_user = User.find(params[:edit_user_id])
      the_user.email = params[:edit_email]
      the_user.username = params[:edit_username]
      the_user.save

      org = Organizer.find(params[:edit_org_id])
      org.election_id = params[:edit_election_id]
      org.access_right_id = params[:edit_access_right_id]
      org.save
    elsif params[:menu] == 'candidate'
      the_user = User.find(params[:edit_user_id])
      the_user.email = params[:edit_email]
      the_user.username = params[:edit_username]
      the_user.save

      cand = Candidate.find(params[:edit_candidate_id])
      cand.election_id = params[:edit_election_id]
      cand.description = params[:edit_description]
      #image
      cand.save
    elsif params[:menu] == 'voter'
      the_user = User.find(params[:edit_user_id])
      the_user.email = params[:edit_email]
      the_user.username = params[:edit_username]
      the_user.save

      vot = Voter.find(params[:edit_voter_id])
      vot.election_id = params[:edit_election_id]
      vot.hasAttend = params[:edit_hasattend].present?
      vot.hasVote = params[:edit_hasvote].present?
      vot.save
    elsif params[:menu] == 'election'
      el = Election.find(params[:edit_election_id])
    elsif params[:menu] == 'access_right'
      ar = AccessRight.find(params[:edit_ar_id])
      ar.name = params[:edit_name]
      ar.save
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def discard
    if params[:menu] == 'organizer'
      Organizer.discard(params[:delete_org_id])
    elsif params[:menu] == 'voter'
      Voter.discard(params[:delete_voter_id])
    elsif params[:menu] == 'candidate'
      Candidate.discard(params[:delete_candidate_id])
    elsif params[:menu] == 'election'
      Election.discard(params[:delete_election_id])
    elsif params[:menu] == 'access_right'
      AccessRight.discard(params[:delete_ar_id])
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
