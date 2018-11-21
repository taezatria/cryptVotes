class VoterController < ApplicationController
  before_action :check_user_login

  def home
    @status = role_user(params[:role])
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @menu = 'home' unless ["result","change_password", "vote", "verify"].include? @menu
    if @menu == "vote"
      check_election
    elsif @menu == 'result'
      @data = vote_result(params[:election])
      @el = Election.find params[:election]
    end
    @name = $redis.get("name"+session[:current_user_id].to_s)
    render :home
  end

  def vote
    if params[:passphrase].present? && params[:vote_candidate_id].present? & params[:vote_election_id].present?
      voter = Voter.find_by(user_id: session[:current_user_id], hasVote: false, hasAttend: true)
      user = User.find_by(id: session[:current_user_id], approved: true, firstLogin: false, deleted_at: nil)
      el = election_now(params[:vote_election_id])
      cand = Candidate.find_by(id: params[:vote_candidate_id], election_id: params[:vote_election_id])
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
            voter.hasVote = true
            voter.save
            $redis.del(user.id.to_s+"Ballot")
            $redis.del(user.id.to_s+"Topup")
            UserMailer.with(user: user, txid: res[:txid], election: el).vote_success.deliver_now
            flash[:success] = "Vote Success !"
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
    redirect_to '/voter?menu=vote'
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
      el = Election.find_by(id: params[:id], deleted_at: nil)
      user = User.find_by(id: session[:current_user_id], deleted_at: nil)
      if el.present? && user.present? && $redis.get(session[:current_user_id].to_s+"Topup").nil?
        Multichain::Multichain.topup(el, user)
        $redis.set(session[:current_user_id].to_s+"Topup", true)
      end
    end
    render :json => { candidate: candidate, other: other, el: el, user: user }
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

  def download
    @result = VoteResult.where(deleted_at: nil)

    respond_to do |format|
      format.html
      format.csv { send_data @result.to_csv, 
      filename: "vote-result-#{Date.today}.csv" }
    end
  end

  def logout
    $redis.del(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
    $redis.del("name"+session[:current_user_id].to_s)
    clear_redis
    reset_session
    flash[:notice] = "You've been logged out"
    redirect_to root_path
  end

  private

  def check_user_login
    stts = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
    if stts.nil?
      flash[:alert] = "You must login first !"
      redirect_back fallback_location: root_path
    else
      stts = stts.split(",")
      unless stts.include? "0"
        flash[:alert] = "You dont have authorize !"
        redirect_to '/organize'
      end
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

  def role_user(role)
    stts = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s).split(",")
    if stts.include? role.to_s
      stts.delete role.to_s
      stts.unshift role.to_s
      $redis.set(User::USER_LOGIN_KEY+session[:current_user_id].to_s, stts.join(","))
    end
    stts
  end

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

  def clear_redis
    $redis.del(session[:current_user_id].to_s+"Ballot")
    $redis.del(session[:current_user_id].to_s+"Topup")
    $redis.del(session[:current_user_id].to_s+"multiaddress")
    $redis.del(session[:current_user_id].to_s+"orgid")
    $redis.del(session[:current_user_id].to_s+"redeemScript")
  end

end
