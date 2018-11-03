class HomeController < ApplicationController
  before_action :check_user_login

  require 'objspace'

  def index  
  end

  def setup_account
    if User.setupAcc(params[:user_id], params[:username], params[:password])
      $opssl.genpkey(params[:user_id], params[:passphrase])
      flash[:success] = "account setup successfully"
      user = User.find(params[:user_id])
      # SendEmailJob.set(wait: 10.seconds).perform_later("welcome", user)
      UserMailer.with(user: user).welcome_email.deliver_later
    else
      flash[:alert] = "failed to setup account"
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
    user = User.find_by(email: params[:verifyemail], approved: true, firstLogin: true, deleted_at: nil)
    if user.present?
      # SendEmailJob.set(wait: 10.seconds).perform_later("verify", user)
      UserMailer.with(user: user).verification_email.deliver_later
      flash[:notice] = "E-mail sent successfully, please to check your inbox"
    else
      flash[:alert] = "Your E-mail doesn't seem to be exist. Please register first or contact the Registration Authorization"
    end
    render :index
  end

  def verify
    if params[:txid].present?
      tx = Multichain::Multichain.get_tx params[:txid]
      if params[:blockhash].present?
        cek = tx["blockhash"] == params[:blockhash]
      end
      render :json => { tx: tx, blockhash: cek, size: ObjectSpace.memsize_of(tx) }
    else
      render :verify
    end
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

  def forget_password
    
  end

  def keygen

  end

  def result
    if params[:id].present?
      @data = vote_result(params[:id])
      @el = Election.find params[:id]
      render :viewresult
    else
      render :result
    end
  end

  def download
    @result = VoteResult.where(deleted_at: nil)

    respond_to do |format|
      format.html
      format.csv { send_data @result.to_csv, 
      filename: "vote-result-#{Date.today}.csv" }
    end
  end

  private

  def vote_result(elect_id)
    res = {}
    VoteResult.group(:data).count.each do |k,v|
      str_key = k.scan(/../).map { |x| x.hex.chr }.join.split('00')
      if str_key[1] == elect_id.to_s
        res[str_key[2]] = v
      end
    end
    res
  end

  def check_user_login
    if $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).present?
      flash[:alert] = "You have logged in!"
      status = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
      if status == "0"
        redirect_to '/voter'
      else
        redirect_to '/organize'
      end
    end
  end
end
