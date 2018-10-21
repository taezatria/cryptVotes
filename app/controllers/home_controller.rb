class HomeController < ApplicationController
  before_action :check_user_login

  def index  
  end

  def setup_account
    if User.setupAcc(params[:user_id], params[:username], params[:password])
      $opssl.genpkey(params[:user_id], params[:passphrase])
      flash[:notice] = "successfully"
      user = User.find(params[:user_id])
      UserMailer.with(user: user).welcome_email.deliver_later
    else
      flash[:alert] = "failed"
    end
    redirect_to '/home'
  end
  
  def setup
    user = User.find_by(id: params[:id], approved: true, firstLogin: true, deleted_at: nil)
    if user.present?
      @user_id = user.id
      render :setup
    else
      redirect_to root_path
    end
  end

  def register
    User.create(
      name: params[:name],
      idNumber: params[:idnumber],
      email: params[:email],
      phone: params[:phone],
      approved: false
    )
    flash[:notice] = "successfully registered. Please wait until the organizer approve it"
    redirect_to :home
  end

  def email
    user = User.find_by(email: params[:email], approved: true, firstLogin: true, deleted_at: nil)
    if user.present?
      UserMailer.with(user: user).verification_email.deliver_later
      flash[:notice] = "E-mail sent successfully"
    else
      @regis = "aaaa"
      flash[:alert] = "Your E-mail doesn't seem to be exist. Please register first or contact the Registration Authorization"
    end
    render :index
  end

  def verify
    render :verify
  end

  def login
    # redirect_to '/organize'
    if params[:username].present? && params[:password].present?
      user = User.login(params[:username], Digest::MD5.hexdigest(params[:password]))
      if user.present?
        session[:current_user_id] = user[:user_id]
        if user[:status] == 0
          redirect_to '/voter'
        else
          redirect_to '/organize'
        end 
      else 
        flash[:alert] = "Username or password doesn't match"
        redirect_back fallback_location: root_path
      end
    end
  end

  def result
    if params[:id].present?
      @dummy = {
        "Abang Randi" => 10,
        "Bung Hassa" => 5,
        "Om Toddi" => 15,
        "Abstance" => 3
      }
      render :viewresult
    else
      render :result
    end
  end

  private

  def check_user_login
    if $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).present?
      flash[:alert] = "You have logged in!"
      status = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
      if status == 0
        redirect_to '/voter'
      else
        redirect_to '/organize'
      end
    end
  end
end
