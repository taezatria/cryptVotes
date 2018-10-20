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
      if organizer.present?
        if organizer.access_right_id == AccessRight.first.id
          status = -1
        else
          status = 1
        end
      elsif voter.present?
        status = 0
      end

      $redis.set(USER_LOGIN_KEY+user.id.to_s, status)
      { user_id: user.id, status: status }
    end
  end

  def self.change_password(user_id, password)
    user = User.find_by(id: user_id, approved: true, firstLogin: false, deleted_at: nil)
    if user.present?
      user.password = password
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
end