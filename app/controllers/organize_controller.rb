require 'csv'

class OrganizeController < ApplicationController
  before_action :check_user_login
  skip_before_action :verify_authenticity_token

  def home
    @status = role_user(params[:role])
    @menu = params[:menu].present? ? params[:menu] : 'home'
    @elec = election_org
    @menu = display_menu(@menu, @status, @elec)
    if @menu == 'result'
      @data = vote_result(params[:election])
      @el = Election.find params[:election]
    end
    @name = $redis.get("name"+session[:current_user_id].to_s)
    render :home
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
    $redis.del("name"+session[:current_user_id].to_s)
    reset_session
    flash[:notice] = "You've been logged out"
    redirect_to root_path
  end

  def add
    if params[:menu] == 'organizer'
      if params[:add_user_id] == "0" || !User.find(params[:add_user_id]).present?
        new_user = User.create(
          name: params[:add_name], 
          idNumber: params[:add_id_number], 
          email: params[:add_email], 
          phone: params[:add_phone],
          approved: true
        )
        params[:add_user_id] = new_user.id
        Multichain::Multichain.new_keypairs(new_user)
      end
      unless Organizer.find_by(user_id: params[:add_user_id], election_id: params[:add_election_id]).present?
        Organizer.create(
          user_id: params[:add_user_id], 
          election_id: params[:add_election_id],
          admin: params[:add_admin].present?
        )
      end
    elsif params[:menu] == 'voter'
      if params[:add_user_id] == "0" || !User.find(params[:add_user_id]).present?
        new_user = User.create(
          name: params[:add_name], 
          idNumber: params[:add_id_number], 
          email: params[:add_email], 
          phone: params[:add_phone],
          approved: true
        )
        params[:add_user_id] = new_user.id
      end
      unless Voter.find_by(user_id: params[:add_user_id], election_id: params[:add_election_id]).present?
        Voter.create(
          user_id: params[:add_user_id],
          election_id: params[:add_election_id]
        )
      end
      el = Election.find(params[:add_election_id])
      c = el.participants
      el.participants = c + 1
      el.save
    elsif params[:menu] == 'candidate'
      item_name = params[:add_image].present? ? save_image(params[:add_image]) : '/assets/default.jpg'
      if params[:add_user_id] == "0" || !User.find(params[:add_user_id]).present?
        new_user = User.create(
          name: params[:add_name], 
          idNumber: params[:add_id_number], 
          email: params[:add_email], 
          phone: params[:add_phone],
          approved: true
        )
        params[:add_user_id] = new_user.id
      end
      unless Candidate.find_by(user_id: params[:add_user_id], election_id: params[:add_election_id]).present?
        Candidate.create(
          user_id: params[:add_user_id],
          election_id: params[:add_election_id],
          description: params[:add_description],
          image: item_name
        )
      end
    elsif params[:menu] == 'election'
      item_name = params[:add_image].present? ? save_image(params[:add_image]) : '/assets/default.jpg'
      if DateTime.now < params[:add_start_date][0]
        sta = 0
      elsif DateTime.now <= params[:add_end_date][0]
        sta = 1
      elsif DateTime.now <= (params[:add_end_date][0].to_date + 6.days)
        sta = 2
      else
        sta = 3
      end
      el = Election.create(
        name: params[:add_name],
        description: params[:add_description],
        start_date: params[:add_start_date][0],
        end_date: params[:add_end_date][0],
        image: item_name,
        status: sta
      )
      Multichain::Multichain.setup_election(el)
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def add_by_file
    if params[:addfile].present? && params[:menu].present?
      data = []
      other = []
      CSV.foreach(params[:addfile].path, :headers => true) do |row|
        user_data = row.to_hash
        other_data = user_data.slice!("name","idNumber","email","phone")
        user = User.create!(user_data)
        if params[:menu] == "organizer"
          other_data["election"] = other_data["election"].split(",")
          other_data["election"].count.times do |i|
            Organizer.create(
              user: user,
              election_id: other_data["election"][i],
              admin: (other_data["admin"][i] == "1")
            )
          end
        elsif params[:menu] == "voter"
          other_data["election"] = other_data["election"].split(",")
          other_data["election"].count.times do |i|
            Voter.create(
              user: user,
              election_id: other_data["election"][i]
            )
            el = Election.find(other_data["election"][i])
            cp = el.participants
            el.participants = cp + 1
            el.save
          end
        elsif params[:menu] == "candidate"
          other_data["election"] = other_data["election"].split(",")
          other_data["election"].count.times do |i|
            Candidate.create(
              user: user,
              election_id: other_data["election"][i],
              image: "person.jpg"
            )
          end
        end
        data.push user_data
        other.push other_data
      end
    end
    render :json => { data: data, other: other }
  end

  def search_by_name
    if params[:menu] == "election"
      if params[:name] == "all"
        user = Election.where(deleted_at: nil)
      else
        user = Election.where('name LIKE ?',"%#{params[:name]}%").where(deleted_at: nil)
      end
    elsif params[:name] == "all"
      user = User.where(deleted_at: nil)
    else
      user = User.where('name LIKE ?',"%#{params[:name]}%").where(deleted_at: nil)
    end
    org = Organizer.find_by(user_id: session[:current_user_id], deleted_at: nil)
    if params[:menu] == 'organizer'
      other = Organizer.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'candidate'
      other = Candidate.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'voter'
      other = Voter.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'election'
      other = nil
    else
      user = nil
      other = nil
    end
    unless org.election_id == 1 || params[:menu] == 'election'
      other = other.where(election_id: org.election_id)
    end
    render :json => { user: user, other: other }
  end

  def search_by_idnumber
    if params[:idnumber] == "all"
      user = User.where(deleted_at: nil)
    else
      user = User.where('idNumber LIKE ?',"%#{params[:idnumber]}%").where(deleted_at: nil)
    end
    org = Organizer.find_by(user_id: session[:current_user_id], deleted_at: nil)
    if params[:menu] == 'organizer'
      other = Organizer.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'candidate'
      other = Candidate.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'voter'
      other = Voter.where(user_id: user.ids, deleted_at: nil)
    else
      user = nil
      other = nil
    end
    unless org.election_id == 1 || params[:menu] == 'election'
      other = other.where(election_id: org.election_id)
    end
    render :json => { user: user, other: other }
  end

  def filter_by_election
    user = User.where(deleted_at: nil)
    org = Organizer.find_by(user_id: session[:current_user_id], deleted_at: nil)
    if params[:menu] == 'organizer'
      other = Organizer.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'candidate'
      other = Candidate.where(user_id: user.ids, deleted_at: nil)
    elsif params[:menu] == 'voter'
      other = Voter.where(user_id: user.ids, deleted_at: nil)
    else
      user = nil
      other = nil
    end
    if org.election_id == 1 && params[:election_id] != "all"
      other = other.where(election_id: params[:election_id])
    elsif org.election_id != 1
      other = other.where(election_id: org.election_id)
    end
    render :json => { user: user, other: other }
  end

  def get_data
    if params[:menu] == 'user'
      user = User.find_by(id: params[:user_id], deleted_at: nil)
    elsif params[:menu] == 'organizer'
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
      #asset_path = '/assets/'+user.image#ActionController::Base.helpers.image_url(user.image)
      other = { start_date: user.start_date.strftime("%Y-%m-%d"), end_date: user.end_date.strftime("%Y-%m-%d") } if user.present?
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

      if Organizer.where(user_id: params[:edit_user_id], election_id: params[:edit_election_id]).count == 1
        org = Organizer.find(params[:edit_org_id])
        org.election_id = params[:edit_election_id]
        org.admin = params[:edit_admin].present?
        org.save
      end
    elsif params[:menu] == 'candidate'
      the_user = User.find(params[:edit_user_id])
      the_user.email = params[:edit_email]
      the_user.username = params[:edit_username]
      the_user.save

      if Candidate.where(user_id: params[:edit_user_id], election_id: params[:edit_election_id]).count == 1
        cand = Candidate.find(params[:edit_candidate_id])
        item_name = params[:edit_image].present? ? save_image(params[:edit_image]) : cand.image
        cand.election_id = params[:edit_election_id]
        cand.description = params[:edit_description]
        cand.image = item_name
        cand.save
      end
    elsif params[:menu] == 'voter'
      the_user = User.find(params[:edit_user_id])
      the_user.email = params[:edit_email]
      the_user.username = params[:edit_username]
      the_user.save

      if Voter.where(user_id: params[:edit_user_id], election_id: params[:edit_election_id]).count == 1
        vot = Voter.find(params[:edit_voter_id])
        vot.election_id = params[:edit_election_id]
        vot.hasAttend = params[:edit_hasattend].present?
        vot.hasVote = params[:edit_hasvote].present?
        vot.save
      end
    elsif params[:menu] == 'election'
      if DateTime.now < params[:edit_start_date][0]
        sta = 0
      elsif DateTime.now <= params[:edit_end_date][0]
        sta = 1
      elsif DateTime.now <= (params[:edit_end_date][0].to_date + 6.days)
        sta = 2
      else
        sta = 3
      end
      el = Election.find(params[:edit_election_id])
      el.name = params[:edit_name]
      el.description = params[:edit_description]
      el.start_date = params[:edit_start_date][0]
      el.end_date = params[:edit_end_date][0]
      item_name = params[:edit_image].present? ? save_image(params[:edit_image]) : el.image
      el.image = item_name
      el.status = sta
      el.save

      if params[:add_participants].present?
        params[:add_participants].each do |part|
          unless Voter.where(user_id: part, election_id: params[:edit_election_id]).present?
            Voter.create(
              user_id: part,
              election_id: params[:edit_election_id]
            )
            co = el.participants
            el.participants = co + 1
            el.save
          end
        end
      end
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
    end
    redirect_to organize_path(menu: params[:menu])
  end

  def tally
    stts = false
    if params[:id].present?
      el = Election.find_by(id: params[:id], deleted_at: nil)
      if el.present?
        Multichain::Multichain.tally_votes(el)
        stts = true
      end
    end
    render :json => { 'status' => stts }
  end

  def anounce
    stts = false
    if params[:id].present?
      el = Election.find(params[:id])
      users = User.joins(:voters).where('voters.election_id' => params[:id], deleted_at: nil).distinct
      if el.present? && users.present?
        AnounceElectionJob.set(wait: 1.seconds).perform_later(users, el)
      end
      stts = true
    end
    render :json => { 'success' => stts }
  end

  def verifyemail
    User.joins(:voters).where(deleted_at: nil).distinct.each do |user|
      SendEmailJob.set(wait: 1.seconds).perform_later("verify", user)
    end
    flash[:notice] = "Sending the e-mail..."
    redirect_to organize_path(menu: "voter")
  end

  def handle_election
    stts = false
    if params[:id].present? && params[:staction].present?
      el = Election.find_by(id: params[:id], deleted_at: nil)
      if el.present? && params[:staction] == "start"
        el.start_date = DateTime.now
        el.status = 1
        el.save
        stts = true
      elsif el.present? && params[:staction] == "stop"
        el.end_date = DateTime.now
        el.status = 2
        el.save
        stts = true
      end
    end
    render :json => { 'success' => stts }
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

  def check_user_login
    stts = $redis.get(User::USER_LOGIN_KEY+session[:current_user_id].to_s)
    if stts.nil?
      flash[:alert] = "You must login first !"
      redirect_back fallback_location: root_path
    else
      stts = stts.split(",")
      unless stts.include?("1") || stts.include?("-1")
      flash[:alert] = "You dont have authorize !"
      redirect_to voter_path
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

  def election_org
    Organizer.find_by(user_id: session[:current_user_id], deleted_at: nil).election_id
  end

  def display_menu(menu, status, elec = 1)
    if status[0].to_i == 1 
      menu = 'home' unless ["result","change_password","voter", "candidate"].include? menu
    elsif status[0].to_i == -1
      menu = 'home' unless ["result","change_password", "election", "organizer"].include? menu
    end
    if elec != 1 && menu == "election"
      menu = 'home'
    end
    menu
  end

  def save_image(img)
    item_name = img.original_filename
    item_path = File.join("public", "assets", item_name)
    File.open(item_path, "wb") do |f|
      f.write(img.read)
    end
    '/assets/'+item_name
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
  
end
