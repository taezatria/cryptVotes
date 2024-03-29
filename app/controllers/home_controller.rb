class HomeController < ApplicationController
  before_action :check_user_login

  require 'objspace'

  def index
  end

  def setup_account
    if User.setupAcc(params[:user_id], params[:username], params[:password])
      if $opssl.genpkey(params[:user_id], params[:passphrase])
        $opssl.genpbkey(params[:user_id], params[:passphrase])
        user = User.find(params[:user_id])
        SendEmailJob.perform_later("welcome", user)
        # UserMailer.with(user: user).welcome_email.deliver_now
        Multichain::Multichain.new_keypairs(user)
        if Organizer.find_by(user_id: params[:user_id]).present?
          $redis.set(params[:user_id].to_s+"passphrase", params[:passphrase])
        end
        flash[:success] = "account setup successfully"
      else
        flash[:alert] = "failed to generate keys"  
      end
    else
      flash[:alert] = "failed to setup account"
    end
    redirect_to root_path
  end
  
  def setup
    user = User.find_by(id: params[:id], approved: true, firstLogin: true, deleted_at: nil)
    if user.present?
      name = user.name
      str = Digest::MD5.hexdigest(params[:id].to_s+name+"setup")
      if params[:str] == str
        @user_id = user.id
        render :setup
      else
        redirect_to root_path
      end
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
    user = User.find_by(email: params[:verifyemail], approved: true, deleted_at: nil)
    if user.present?
      user.firstLogin = true
      user.save
      SendEmailJob.perform_later("verify", user)
      # UserMailer.with(user: user).verification_email.deliver_now
      flash[:notice] = "E-mail sent successfully, please to check your inbox"
    else
      flash[:alert] = "Your E-mail doesn't seem to be exist. Please register first or contact the Registration Authorization"
      @regis = true
    end
    render :index
  end

  def verify
    if params[:txid].present?
      tx = Multichain::Multichain.get_tx params[:txid]
      if params[:blockhash].present?
        cek = tx["blockhash"] == params[:blockhash]
      end
      data = tx["data"][0].scan(/../).map { |x| x.hex.chr }.join.split("0x0")[2]
      tx["data"] = data
      render :json => { tx: tx, blockhash: cek, size: ObjectSpace.memsize_of(tx) }
    else
      render :verify
    end
  end

  def login
    if params[:username].present? && params[:password].present?
      user = User.login(params[:username], Digest::MD5.hexdigest(params[:password]))
      # user = User.login_testing(params[:username], params[:password], 5)
      if user.present?
        session[:current_user_id] = user[:user_id]
        if user[:status][0] == 0
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
    if params[:id].present?
      user = User.find_by(id: params[:id], approved: true, firstLogin: false, deleted_at: nil)
      if user.present?
        name = user.name
        str = Digest::MD5.hexdigest(params[:id].to_s+name+"password")
        if params[:str] == str
          @user_id = user.id
          @menu = "password"
          render :reset
        else
          flash[:alert] = "Link doesn't exist"
          redirect_to root_path
        end
      else
        flash[:alert] = "User doesn't exist"
        redirect_to root_path
      end
    elsif params[:user_id].present?
      user = User.find_by(id: params[:user_id], approved: true, firstLogin: false, deleted_at: nil)
      flash[:alert] = 'New password and retype password dont match' if params[:newpassword] != params[:retypepassword]
      unless flash[:alert].present? || user.nil?
        user.password = Digest::MD5.hexdigest(params[:newpassword])
        user.save
        flash[:notice] = 'Password saved successfully'
      else
        flash[:alert] ||= "User doesn't exist"
      end
      redirect_to root_path
    elsif params[:verifyemail].present?
      user = User.find_by(email: params[:verifyemail], approved: true, deleted_at: nil)
      if user.present?
        SendEmailJob.perform_later("password", user)
        # UserMailer.with(user: user).forget_password.deliver_now
        flash[:success] = "E-mail sent successfully, please to check your inbox"
      else
        flash[:alert] = "Your E-mail doesn't seem to be exist. Please register first or contact the Registration Authorization"
        @regis = true
      end
      render :index
    else
      redirect_to root_path
    end
  end

  def keygen
    if params[:id].present?
      user = User.find_by(id: params[:id], approved: true, firstLogin: false, deleted_at: nil)
      if user.present?
        name = user.name
        str = Digest::MD5.hexdigest(params[:id].to_s+name+"passphrase")
        if params[:str] == str
          @user_id = user.id
          @menu = "passphrase"
          render :reset
        else
          flash[:alert] = "Link doesn't exist"
          redirect_to root_path
        end
      else
        flash[:alert] = "User doesn't exist"
        redirect_to root_path
      end
    elsif params[:user_id].present?
      user = User.find_by(id: params[:user_id], approved: true, firstLogin: false, deleted_at: nil)
      if user.present?
        if $opssl.genpkey(params[:user_id], params[:passphrase])
          $opssl.genpbkey(params[:user_id], params[:passphrase])
          Multichain::Multichain.new_keypairs(user)
          if Organizer.find_by(user_id: params[:user_id]).present?
            $redis.set(params[:user_id].to_s+"passphrase", params[:passphrase])
          end
          flash[:success] = "account setup successfully"
        else
          flash[:alert] = "failed to generate keys" 
        end 
      else
        flash[:alert] = "User doesn't exist"
      end
      redirect_to root_path
    elsif params[:verifyemail].present?
      user = User.find_by(email: params[:verifyemail], approved: true, deleted_at: nil)
      if user.present?
        SendEmailJob.perform_later("passphrase", user)
        # UserMailer.with(user: user).passphrase_reset.deliver_now
        flash[:success] = "E-mail sent successfully, please to check your inbox"
      else
        flash[:alert] = "Your E-mail doesn't seem to be exist. Please register first or contact the Registration Authorization"
        @regis = true
      end
      render :index
    else
      redirect_to root_path
    end
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
      str_key = k.scan(/../).map { |x| x.hex.chr }.join.split('0x0')
      if str_key[1] == elect_id.to_s
        if str_key[0] == "0"
          count += Voter.where(election_id: elect_id, hasVote: false).count
        end
        res[str_key[2]] = v
      end
    end
    res
  end

  def check_user_login
    if $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).present?
      flash[:alert] = "You have logged in!"
      status = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).split(",")
      if status[0] == "0"
        redirect_to '/voter'
      else
        redirect_to '/organize'
      end
    end
  end
end
