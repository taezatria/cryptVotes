class User < ApplicationRecord
  USER_LOGIN_KEY = "userloggedin".freeze

  has_many :voters
  has_many :candidates
  has_many :organizers
  has_many :transactions

  def self.login(username, password)
    user = User.find_by(username: username, password: password, approved: true, firstLogin: false, deleted_at: nil)
    
    if user.present?
      organizer = Organizer.find_by(user_id: user.id)
      voter = Voter.find_by(user_id: user.id)
      status = []
      if organizer.present?
        if organizer.admin
          status.push -1
        else
          status.push 1
        end
      end
      if voter.present?
        status.push 0
      end

      if user.id == 1
        status.push 1
        status.push 0
      end

      $redis.set(USER_LOGIN_KEY+user.id.to_s, status.join(","))
      $redis.set("name"+user.id.to_s, user.name)
      { user_id: user.id, status: status }
    end
  end

  def self.change_password(user_id, password)
    user = User.find_by(id: user_id, approved: true, firstLogin: false, deleted_at: nil)
    if user.present?
      user.password = Digest::MD5.hexdigest(password)
      user.save
    end
  end

  def self.approve(user_id)
    user = User.find_by(id: user_id, approved: false, firstLogin: false, deleted_at: nil)
    user.approved = true
    user.save
  end

  def self.setupAcc(id, username, password)
    the_user = User.find_by(id: id, approved: true, firstLogin: true, deleted_at: nil)
    if the_user.present?
      the_user.username = username.downcase
      the_user.password = Digest::MD5.hexdigest(password)
      the_user.firstLogin = false
      the_user.save
    else
      false
    end
  end

  def self.discard(id)
    user = User.find(id)
    user.deleted_at = DateTime.now
    user.save
  end

  def self.login_testing(username, password, el_id)
    status = []
    user = User.find_by(username: username, approved: true, firstLogin: false, deleted_at: nil)
    unless user.present?
      user = User.create(
        name: username,
        idNumber: username,
        email: username+"@john.petra.ac.id",
        phone: username,
        username: username,
        password: Digest::MD5.hexdigest(password),
        approved: true,
        firstLogin: false
      )
      $opssl.genpkey(user.id, "123456")
      $opssl.genpbkey(user.id, "123456")
      $redis.set(user.id.to_s+"passphrase", "123456")
      Multichain::Multichain.new_keypairs(user)
      Voter.create(
        user: user,
        election_id: el_id,
        hasAttend: true
      )
      el = Election.find(el_id)
      c = el.participants
      el.participants = c + 1
      el.save

      status.push 0
      $redis.set(USER_LOGIN_KEY+user.id.to_s, status.join(","))
      $redis.set("name"+user.id.to_s, user.name)
      { user_id: user.id, status: status }
    else
      if user.password == Digest::MD5.hexdigest(password)
        status.push 0
        $redis.set(USER_LOGIN_KEY+user.id.to_s, status.join(","))
        $redis.set("name"+user.id.to_s, user.name)
        { user_id: user.id, status: status }
      end
    end
    
  end

end