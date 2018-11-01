class VoterController < ApplicationController
  before_action :check_user_login

  def home
    @status = role_user
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @menu = 'home' unless ["change_password", "vote", "verify"].include? @menu
    if @menu == "vote"
      check_election
    end
    render :home
  end

  def vote
    if params[:passphrase].present? && params[:candidate_id].present? & params[:vote_election_id].present?
      voter = Voter.find_by(user_id: session[:current_user_id], hasVote: false, hasAttend: true)
      user = User.find_by(id: session[:current_user_id], approved: true, firstLogin: false, deleted_at: nil)
      el = election_now(params[:vote_election_id])
      cand = Candidate.find_by(id: params[:candidate_id], election_id: params[:vote_election_id])
      candidate = User.find_by(id: cand.user_id, approved: true, deleted_at: nil)
      if voter.present? && user.present? && el.present? && candidate.present?
        privkey = $opssl.decrypt(user.id, params[:passphrase], user.privateKey)
        if privkey.present?
          rawdata = [candidate.id, el.id, candidate.name, cand.id].join("0x0")
          data = rawdata.each_byte.map { |b| b.to_s(16) }.join
          res = Multichain::Multichain.vote(el, user, privkey, data)
          if res[:txid].present? && res[:digsign].present?
            ctx = $opssl.encrypt(user.id, res[:txid])
            cdig = $opssl.encrypt(user.id, res[:digsign])
            Transaction.create(
              user: user,
              election: el,
              txid: ctx,
              digSign: cdig
            )
            $redis.del(user.id.to_s+"Ballot")
            flash[:notice] = "success, txid: "+ res[:txid]
          else
            flash[:alert] = "failed to vote"
          end
        else
          flash[:alert] = "wrong passphrase"
        end
      else
        flash[:alert] = "datas are not valid"
      end
    else
      flash[:alert] = "datas are not completed"
    end
    redirect_to '/voter'
  end

  def verify
    if params[:openverify].present? && params[:elect_id].present? && params[:passphrase].present?
      tx = Transaction.find_by(user_id: session[:current_user_id], election_id: params[:elect_id], deleted_at: nil)
      if params[:openverify] == "open" && tx.present?
        txid = $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.txid)
        if txid.present?
          txs = Multichain::Multichain.get_tx(txid)
          $redis.set(session[:current_user_id].to_s+"txhex", txs["hex"])
          status = 0
        end
      elsif params[:openverify] == "verify" && tx.present?
        digsign = $opssl.decrypt(session[:current_user_id], params[:passphrase], tx.digSign)
        if digsign.present?
          $redis.set(session[:current_user_id].to_s+"digsign", digsign)
          verifystatus = Multichain::Multichain.verify(session[:current_user_id])
          status = 1
        end
      end
    end
    render :json => { "status": status, tx: txs, "verifystatus": verifystatus }
  end

  def get_candidate
    stts = nil
    if params[:id].present?
      other = []
      candidate = Candidate.where(election_id: params[:id], deleted_at: nil);
      candidate.each do |cand|
        other.push(User.find_by(id: cand.user_id, deleted_at: nil))
      end
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

  def election_now(el)
    Election.where('? BETWEEN start_date AND end_date', DateTime.now).find_by(id: el, status: 1, deleted_at: nil)
  end

  def check_election
    if $redis.get(session[:current_user_id].to_s+"Ballot").nil?
      el = []
      Voter.where(user_id: session[:current_user_id], hasVote: false, hasAttend: true, deleted_at: nil).each do |voter|
        el.push(voter.election_id)
      end
      co = Election.where(id: el, status: 1, deleted_at: nil).where('? BETWEEN start_date AND end_date', DateTime.now).count
      if co > 0
        user = User.find_by(id: session[:current_user_id], approved: true, firstLogin: false, deleted_at:nil)
        Multichain::Multichain.prepare_ballot(user)
        $redis.set(user.id.to_s+"Ballot", true)
      end
    end
  end

  def role_user
    $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).to_i
  end

end
