class VoterController < ApplicationController
  before_action :check_user_login

  def home
    @status = role_user
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @menu = 'home' unless ["change_password", "vote", "verify"].include? @menu
    render :home
  end

  def vote
    if params[:passphrase].present? && params[:candidate_id].present? & params[:vote_election_id].present?
      if $opssl.genpbkey(session[:current_user_id].to_s, params[:passphrase])
        flash[:notice] = "berhasil"
      else
        flash[:alert] = "gagal"
      end
    end
    redirect_to '/voter'
  end

  def verify
    if params[:openverify].present? && params[:elect_id].present? && params[:passphrase].present?
      # tx = Transaction.find_by(user_id: session[:current_user_id], election_id: params[:elect_id], deleted_at: nil)
      if params[:openverify] == "open"
        # $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.txid)
        status = 0
      elsif params[:openverify] == "verify"
        # $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.digsign)
        status = 1
      end
    else
      status = nil
    end
    render :json => { "status": status }
  end

  def get_candidate
    if params[:id].present?
      other = []
      candidate = Candidate.where(election_id: params[:id], deleted_at: nil);
      candidate.each do |cand|
        other.push(User.find_by(id: cand.user_id, deleted_at: nil))
      end
    else
      candidate = nil
    end
    render :json => { candidate: candidate, other: other }
  end

  def change_password
    if params[:oldpassword].present? && params[:newpassword].present? && params[:retypepassword].present?
      user = User.find_by(id: session[:current_user_id], deleted_at: nil)
      flash[:alert] = 'Old password is wrong' if user.password != Digest::MD5.hexdigest(params[:oldpassword])
      flash[:alert] = 'New password and retype password dont match' if params[:newpassword] != params[:retypepassword]
      unless flash[:alert].present?
        user.password = Digest::MD5.hexdigest(params[:newpassword])
        user.save
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
    if $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).nil?
      flash[:alert] = "You must login first !"
      redirect_back fallback_location: root_path
    end
  end

  def check_election
    el = []
    Voter.where(user_id: session[:current_user_id]).each do |voter|
      el.push(voter.election_id)
    end
    co = Election.where(id: el, status: 1, deleted_at: nil).where('? BETWEEN start_date AND end_date', DateTime.now).count
    co != 0
  end

  def role_user
    $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).to_i
  end

end
