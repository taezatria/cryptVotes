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
      voter = Voter.find_by(user_id: session[:current_user_id], hasVote: false, hasAttend: true)
      user = User.find_by(id: session[:current_user_id], approved: true, firstLogin: false, deleted_at: nil)
      el = election_now(params[:vote_election_id])
      if voter.present? && user.present? && el.present?
        privkey = $opssl.decrypt(user.id, params[:passphrase], user.privateKey)
        if privkey.present?
          res = Multichain::Multichain.vote(el, addr, user, privkey)
          if res[:txid].present? && res[:digsign].present?
            Transaction.create(
              user: user,
              election: el,
              txid: res[:txid],
              digsign: res[:digsign]
            )
          end
        end
        flash[:notice] = "berhasil"
      else
        flash[:alert] = "gagal"
      end
    end
    redirect_to '/voter'
  end

  def verify
    if params[:openverify].present? && params[:elect_id].present? && params[:passphrase].present?
      tx = Transaction.find_by(user_id: session[:current_user_id], election_id: params[:elect_id], deleted_at: nil)
      if params[:openverify] == "open" && tx.present?
        txid = $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.txid)
        tx = Multichain::Multichain.get_tx(txid)
        $redis.set(session[:current_user_id].to_s+"txhex", tx["hex"])
        status = 0
      elsif params[:openverify] == "verify" && tx.present?
        digsign = $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.digsign)
        $redis.set(session[:current_user_id].to_s+"txhex", digsign)
        verifystatus = Multichain::Multichain.verify(session[:current_user_id])
        status = 1
      end
    end
    render :json => { "status": status, tx: tx, "verifystatus": verifystatus }
  end

  def get_candidate
    stts = nil
    if params[:id].present?
      other = []
      candidate = Candidate.where(election_id: params[:id], deleted_at: nil);
      candidate.each do |cand|
        other.push(User.find_by(id: cand.user_id, deleted_at: nil))
      end
      if candidate.present? && other.present?
        stts = Multichain::Multichain.prepare_ballot(session[:current_user_id])
      end
    end
    render :json => { status: stts == "OK", candidate: candidate, other: other }
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

  def election_now(el)
    Election.find_by(id: el, status: 1, deleted_at: nil).where('? BETWEEN start_date AND end_date', DateTime.now)
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
